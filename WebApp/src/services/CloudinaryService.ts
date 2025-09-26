// Cloudinary service for uploading images and audio files
// This matches the functionality from the Flutter app's CloudinaryService

export class CloudinaryService {
  private static readonly CLOUD_NAME = import.meta.env.VITE_CLOUDINARY_CLOUD_NAME;
  private static readonly UPLOAD_PRESET = import.meta.env.VITE_CLOUDINARY_UPLOAD_PRESET;
  private static readonly BASE_URL = `https://api.cloudinary.com/v1_1/${this.CLOUD_NAME}`;

  // Upload image file to Cloudinary
  static async uploadImage(file: File): Promise<string | null> {
    try {
      if (!this.CLOUD_NAME || !this.UPLOAD_PRESET) {
        console.error('Cloudinary configuration missing. Please set VITE_CLOUDINARY_CLOUD_NAME and VITE_CLOUDINARY_UPLOAD_PRESET');
        return null;
      }

      const formData = new FormData();
      formData.append('file', file);
      formData.append('upload_preset', this.UPLOAD_PRESET);
      formData.append('folder', 'civicsync/images');

      const response = await fetch(`${this.BASE_URL}/image/upload`, {
        method: 'POST',
        body: formData,
      });

      if (!response.ok) {
        throw new Error(`Upload failed: ${response.statusText}`);
      }

      const data = await response.json();
      return data.secure_url;
    } catch (error) {
      console.error('Error uploading image:', error);
      return null;
    }
  }

  // Upload audio file to Cloudinary
  static async uploadAudio(file: File): Promise<string | null> {
    try {
      if (!this.CLOUD_NAME || !this.UPLOAD_PRESET) {
        console.error('Cloudinary configuration missing. Please set VITE_CLOUDINARY_CLOUD_NAME and VITE_CLOUDINARY_UPLOAD_PRESET');
        return null;
      }

      const formData = new FormData();
      formData.append('file', file);
      formData.append('upload_preset', this.UPLOAD_PRESET);
      formData.append('folder', 'civicsync/audio');
      formData.append('resource_type', 'auto'); // Allows audio files

      const response = await fetch(`${this.BASE_URL}/raw/upload`, {
        method: 'POST',
        body: formData,
      });

      if (!response.ok) {
        throw new Error(`Upload failed: ${response.statusText}`);
      }

      const data = await response.json();
      return data.secure_url;
    } catch (error) {
      console.error('Error uploading audio:', error);
      return null;
    }
  }

  // Upload any file (images, audio, video, etc.)
  static async uploadFile(file: File, folder?: string): Promise<string | null> {
    try {
      if (!this.CLOUD_NAME || !this.UPLOAD_PRESET) {
        console.error('Cloudinary configuration missing. Please set VITE_CLOUDINARY_CLOUD_NAME and VITE_CLOUDINARY_UPLOAD_PRESET');
        return null;
      }

      const formData = new FormData();
      formData.append('file', file);
      formData.append('upload_preset', this.UPLOAD_PRESET);
      formData.append('resource_type', 'auto');
      
      if (folder) {
        formData.append('folder', `civicsync/${folder}`);
      } else {
        formData.append('folder', 'civicsync/misc');
      }

      // Determine the correct endpoint based on file type
      const isImage = file.type.startsWith('image/');
      const endpoint = isImage ? 'image/upload' : 'raw/upload';

      const response = await fetch(`${this.BASE_URL}/${endpoint}`, {
        method: 'POST',
        body: formData,
      });

      if (!response.ok) {
        throw new Error(`Upload failed: ${response.statusText}`);
      }

      const data = await response.json();
      return data.secure_url;
    } catch (error) {
      console.error('Error uploading file:', error);
      return null;
    }
  }

  // Validate file before upload
  static validateFile(file: File, maxSizeMB: number = 10): { valid: boolean; error?: string } {
    // Check file size
    const maxSizeBytes = maxSizeMB * 1024 * 1024;
    if (file.size > maxSizeBytes) {
      return { valid: false, error: `File size exceeds ${maxSizeMB}MB limit` };
    }

    // Check file type for images
    if (file.type.startsWith('image/')) {
      const allowedImageTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
      if (!allowedImageTypes.includes(file.type)) {
        return { valid: false, error: 'Invalid image format. Allowed: JPEG, PNG, GIF, WebP' };
      }
    }

    // Check file type for audio
    if (file.type.startsWith('audio/')) {
      const allowedAudioTypes = ['audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/m4a', 'audio/aac'];
      if (!allowedAudioTypes.includes(file.type)) {
        return { valid: false, error: 'Invalid audio format. Allowed: MP3, WAV, M4A, AAC' };
      }
    }

    return { valid: true };
  }

  // Get optimized image URL with transformations
  static getOptimizedImageUrl(originalUrl: string, options?: {
    width?: number;
    height?: number;
    quality?: 'auto' | number;
    format?: 'auto' | 'jpg' | 'png' | 'webp';
  }): string {
    if (!originalUrl || !originalUrl.includes('cloudinary.com')) {
      return originalUrl;
    }

    try {
      const url = new URL(originalUrl);
      const pathParts = url.pathname.split('/');
      const uploadIndex = pathParts.findIndex(part => part === 'upload');
      
      if (uploadIndex === -1) return originalUrl;

      const transformations = [];
      
      if (options?.width) transformations.push(`w_${options.width}`);
      if (options?.height) transformations.push(`h_${options.height}`);
      if (options?.quality) transformations.push(`q_${options.quality}`);
      if (options?.format) transformations.push(`f_${options.format}`);
      
      // Add default optimizations
      if (!options?.quality) transformations.push('q_auto');
      if (!options?.format) transformations.push('f_auto');
      
      if (transformations.length > 0) {
        pathParts.splice(uploadIndex + 1, 0, transformations.join(','));
      }
      
      url.pathname = pathParts.join('/');
      return url.toString();
    } catch (error) {
      console.error('Error creating optimized URL:', error);
      return originalUrl;
    }
  }
}