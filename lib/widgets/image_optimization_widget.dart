import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';

/// Progressive image loading with optimization
class ProgressiveImage extends StatefulWidget {
  final String imageUrl;
  final String? lowResUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableMemoryCache;
  final bool enableDiskCache;
  final Duration fadeInDuration;

  const ProgressiveImage({
    super.key,
    required this.imageUrl,
    this.lowResUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.enableMemoryCache = true,
    this.enableDiskCache = true,
    this.fadeInDuration = const Duration(milliseconds: 500),
  });

  @override
  State<ProgressiveImage> createState() => _ProgressiveImageState();
}

class _ProgressiveImageState extends State<ProgressiveImage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _lowResLoaded = false;
  bool _highResLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.fadeInDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          // Low resolution image (if provided)
          if (widget.lowResUrl != null && !_highResLoaded)
            CachedNetworkImage(
              imageUrl: widget.lowResUrl!,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              memCacheWidth: widget.width?.toInt(),
              memCacheHeight: widget.height?.toInt(),
              placeholder: (context, url) => widget.placeholder ?? _buildDefaultPlaceholder(),
              errorWidget: (context, url, error) => widget.errorWidget ?? _buildDefaultError(),
              fadeInDuration: const Duration(milliseconds: 200),
              imageBuilder: (context, imageProvider) {
                if (!_lowResLoaded) {
                  _lowResLoaded = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) _controller.forward();
                  });
                }
                return AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) => Opacity(
                    opacity: _animation.value,
                    child: Image(
                      image: imageProvider,
                      width: widget.width,
                      height: widget.height,
                      fit: widget.fit,
                    ),
                  ),
                );
              },
            ),

          // High resolution image
          CachedNetworkImage(
            imageUrl: widget.imageUrl,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            memCacheWidth: widget.width?.toInt(),
            memCacheHeight: widget.height?.toInt(),
            placeholder: (context, url) => 
                _lowResLoaded ? const SizedBox.shrink() : 
                (widget.placeholder ?? _buildDefaultPlaceholder()),
            errorWidget: (context, url, error) => widget.errorWidget ?? _buildDefaultError(),
            fadeInDuration: widget.fadeInDuration,
            imageBuilder: (context, imageProvider) {
              if (!_highResLoaded) {
                _highResLoaded = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _controller.forward();
                });
              }
              return AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => Opacity(
                  opacity: _animation.value,
                  child: Image(
                    image: imageProvider,
                    width: widget.width,
                    height: widget.height,
                    fit: widget.fit,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      ),
    );
  }

  Widget _buildDefaultError() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.error_outline,
          color: AppColors.errorRed,
          size: 32,
        ),
      ),
    );
  }
}

/// Lazy loading list view for images
class LazyImageList extends StatefulWidget {
  final List<String> imageUrls;
  final double itemHeight;
  final EdgeInsets? padding;
  final Function(int)? onImageTapped;

  const LazyImageList({
    super.key,
    required this.imageUrls,
    this.itemHeight = 200,
    this.padding,
    this.onImageTapped,
  });

  @override
  State<LazyImageList> createState() => _LazyImageListState();
}

class _LazyImageListState extends State<LazyImageList> {
  final Set<int> _loadedImages = {};
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final viewportHeight = _scrollController.position.viewportDimension;
    final scrollOffset = _scrollController.offset;
    
    // Calculate which items should be loaded
    final firstVisibleIndex = (scrollOffset / widget.itemHeight).floor();
    final lastVisibleIndex = ((scrollOffset + viewportHeight) / widget.itemHeight).ceil();
    
    // Load images for visible items plus buffer
    for (int i = firstVisibleIndex - 2; i <= lastVisibleIndex + 2; i++) {
      if (i >= 0 && i < widget.imageUrls.length && !_loadedImages.contains(i)) {
        setState(() {
          _loadedImages.add(i);
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: widget.padding,
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index) {
        final shouldLoad = _loadedImages.contains(index);
        
        return GestureDetector(
          onTap: () => widget.onImageTapped?.call(index),
          child: Container(
            height: widget.itemHeight,
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              child: shouldLoad
                  ? ProgressiveImage(
                      imageUrl: widget.imageUrls[index],
                      height: widget.itemHeight,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 48,
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

/// Optimized product image gallery
class ProductImageGallery extends StatefulWidget {
  final List<String> images;
  final double height;
  final Function(int)? onImageChanged;

  const ProductImageGallery({
    super.key,
    required this.images,
    this.height = 300,
    this.onImageChanged,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main image display
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              widget.onImageChanged?.call(index);
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  child: ProgressiveImage(
                    imageUrl: widget.images[index],
                    height: widget.height,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Thumbnail strip
        if (widget.images.length > 1)
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                final isSelected = index == _currentIndex;
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      border: isSelected
                          ? Border.all(
                              color: AppColors.primaryGreen,
                              width: 2,
                            )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      child: ProgressiveImage(
                        imageUrl: widget.images[index],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        // Page indicators
        if (widget.images.length > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: index == _currentIndex ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: index == _currentIndex
                      ? AppColors.primaryGreen
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Avatar with fallback and loading
class OptimizedAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final Color? backgroundColor;

  const OptimizedAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 40,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryGreen.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildInitials(),
                errorWidget: (context, url, error) => _buildInitials(),
              ),
            )
          : _buildInitials(),
    );
  }

  Widget _buildInitials() {
    final initials = name.split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .take(2)
        .join();
    
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}
