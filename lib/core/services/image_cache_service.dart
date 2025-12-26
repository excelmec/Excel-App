import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  final Map<String, Uint8List> _memoryCache = {};
  final int _maxMemoryCacheSize = 50;

  /// Get cache directory for images
  Future<Directory> _getCacheDirectory() async {
    final directory = await getTemporaryDirectory();
    final cacheDir = Directory('${directory.path}/image_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  /// Generate a unique filename from URL
  String _generateCacheKey(String url) {
    return md5.convert(utf8.encode(url)).toString();
  }

  /// Load image from cache or download
  Future<Uint8List?> getImage(String url) async {
    // Check memory cache first
    if (_memoryCache.containsKey(url)) {
      return _memoryCache[url];
    }

    // Check disk cache
    final cacheKey = _generateCacheKey(url);
    final cacheDir = await _getCacheDirectory();
    final file = File('${cacheDir.path}/$cacheKey');

    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      _addToMemoryCache(url, bytes);
      return bytes;
    }

    // Download and cache
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        await file.writeAsBytes(bytes);
        _addToMemoryCache(url, bytes);
        return bytes;
      }
    } catch (e) {
      // Silently fail for production
    }

    return null;
  }

  /// Add image to memory cache with LRU eviction
  void _addToMemoryCache(String url, Uint8List bytes) {
    if (_memoryCache.length >= _maxMemoryCacheSize) {
      _memoryCache.remove(_memoryCache.keys.first);
    }
    _memoryCache[url] = bytes;
  }

  /// Clear all cache
  Future<void> clearCache() async {
    _memoryCache.clear();
    final cacheDir = await _getCacheDirectory();
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
  }

  /// Get cache size in bytes
  Future<int> getCacheSize() async {
    final cacheDir = await _getCacheDirectory();
    if (!await cacheDir.exists()) return 0;

    int totalSize = 0;
    await for (final entity in cacheDir.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    return totalSize;
  }
}

/// Cached Image Widget
class CachedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  final ImageCacheService _cacheService = ImageCacheService();
  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final bytes = await _cacheService.getImage(widget.imageUrl);
      if (mounted) {
        setState(() {
          _imageBytes = bytes;
          _isLoading = false;
          _hasError = bytes == null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_isLoading) {
      child =
          widget.placeholder ??
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.white.withOpacity(0.1),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                ),
              ),
            ),
          );
    } else if (_hasError || _imageBytes == null) {
      child =
          widget.errorWidget ??
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: widget.borderRadius,
            ),
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.white54,
              size: 30,
            ),
          );
    } else {
      child = Image.memory(
        _imageBytes!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    if (widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: child);
    }

    return child;
  }
}
