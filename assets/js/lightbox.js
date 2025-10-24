// Simple Lightbox Implementation
class Lightbox {
  constructor() {
    this.currentIndex = 0;
    this.images = [];
    this.init();
  }

  init() {
    // Create lightbox HTML
    this.createLightboxHTML();
    
    // Find all clickable images
    this.findImages();
    
    // Add click event listeners
    this.addEventListeners();
    
    // Add keyboard navigation
    this.addKeyboardNavigation();
  }

  createLightboxHTML() {
    const lightboxHTML = `
      <div id="lightbox" class="lightbox">
        <div class="lightbox-content">
          <button class="lightbox-close" title="Close"><i class="fas fa-times"></i></button>
          <button class="lightbox-nav lightbox-prev" title="Previous"><i class="fas fa-chevron-left"></i></button>
          <button class="lightbox-nav lightbox-next" title="Next"><i class="fas fa-chevron-right"></i></button>
          <img id="lightbox-image" src="" alt="">
          <div class="lightbox-caption" id="lightbox-caption"></div>
        </div>
      </div>
    `;
    
    document.body.insertAdjacentHTML('beforeend', lightboxHTML);
    
    this.lightbox = document.getElementById('lightbox');
    this.lightboxImage = document.getElementById('lightbox-image');
    this.lightboxCaption = document.getElementById('lightbox-caption');
  }

  findImages() {
    // Find all images in carousels and other image galleries
    const imageLinks = document.querySelectorAll('.image-gallery-index a, .image-gallery a, .blog-post img, article img');
    
    this.images = Array.from(imageLinks).map((link, index) => {
      const img = link.querySelector('img') || link;
      const src = img.src || link.href;
      const alt = img.alt || link.title || '';
      
      // Store original link for reference
      link.dataset.lightboxIndex = index;
      
      return {
        src: src,
        alt: alt,
        element: link
      };
    });
    
    // Group images by carousel
    this.groupImagesByCarousel();
  }

  groupImagesByCarousel() {
    const carousels = document.querySelectorAll('.image-gallery-index');
    this.carouselGroups = [];
    
    carousels.forEach(carousel => {
      const images = Array.from(carousel.querySelectorAll('a')).map(link => {
        const img = link.querySelector('img');
        const src = img.src || link.href;
        const alt = img.alt || link.title || '';
        
        return {
          src: src,
          alt: alt,
          element: link
        };
      });
      
      if (images.length > 0) {
        this.carouselGroups.push(images);
      }
    });
  }

  addEventListeners() {
    // Add click listeners to carousel images
    this.carouselGroups.forEach((group, groupIndex) => {
      group.forEach((image, imageIndex) => {
        image.element.addEventListener('click', (e) => {
          e.preventDefault();
          this.openCarousel(groupIndex, imageIndex);
        });
      });
    });

    // Add click listeners to other images (not in carousels)
    const otherImages = document.querySelectorAll('.blog-post img, article img');
    otherImages.forEach((img, index) => {
      if (!img.closest('.image-gallery-index') && !img.classList.contains('no-lightbox')) {
        img.addEventListener('click', (e) => {
          e.preventDefault();
          this.openSingle(img.src, img.alt);
        });
      }
    });

    // Lightbox controls
    document.querySelector('.lightbox-close').addEventListener('click', () => this.close());
    document.querySelector('.lightbox-prev').addEventListener('click', () => this.prev());
    document.querySelector('.lightbox-next').addEventListener('click', () => this.next());
    
    // Close on background click
    this.lightbox.addEventListener('click', (e) => {
      if (e.target === this.lightbox) {
        this.close();
      }
    });
  }

  addKeyboardNavigation() {
    document.addEventListener('keydown', (e) => {
      if (!this.lightbox.classList.contains('active')) return;
      
      switch(e.key) {
        case 'Escape':
          this.close();
          break;
        case 'ArrowLeft':
          this.prev();
          break;
        case 'ArrowRight':
          this.next();
          break;
      }
    });
  }

  openCarousel(groupIndex, imageIndex) {
    if (groupIndex < 0 || groupIndex >= this.carouselGroups.length) return;
    if (imageIndex < 0 || imageIndex >= this.carouselGroups[groupIndex].length) return;
    
    this.currentGroup = groupIndex;
    this.currentIndex = imageIndex;
    this.currentImages = this.carouselGroups[groupIndex];
    
    const image = this.currentImages[imageIndex];
    
    this.lightboxImage.src = image.src;
    this.lightboxImage.alt = image.alt;
    this.lightboxCaption.textContent = image.alt;
    
    this.lightbox.classList.add('active');
    document.body.style.overflow = 'hidden'; // Prevent scrolling
    
    // Update navigation buttons
    this.updateNavigation();
  }

  openSingle(src, alt) {
    this.currentImages = [{ src: src, alt: alt }];
    this.currentIndex = 0;
    
    this.lightboxImage.src = src;
    this.lightboxImage.alt = alt;
    this.lightboxCaption.textContent = alt;
    
    this.lightbox.classList.add('active');
    document.body.style.overflow = 'hidden';
    
    // Update navigation buttons
    this.updateNavigation();
  }

  close() {
    this.lightbox.classList.remove('active');
    document.body.style.overflow = ''; // Restore scrolling
  }

  prev() {
    const newIndex = this.currentIndex > 0 ? this.currentIndex - 1 : this.currentImages.length - 1;
    this.openCarousel(this.currentGroup, newIndex);
  }

  next() {
    const newIndex = this.currentIndex < this.currentImages.length - 1 ? this.currentIndex + 1 : 0;
    this.openCarousel(this.currentGroup, newIndex);
  }

  updateNavigation() {
    const prevBtn = document.querySelector('.lightbox-prev');
    const nextBtn = document.querySelector('.lightbox-next');
    
    // Hide navigation if only one image
    if (this.currentImages.length <= 1) {
      prevBtn.style.display = 'none';
      nextBtn.style.display = 'none';
    } else {
      // Show/hide based on current position
      prevBtn.style.display = this.currentIndex > 0 ? 'flex' : 'none';
      nextBtn.style.display = this.currentIndex < this.currentImages.length - 1 ? 'flex' : 'none';
    }
  }
}

// Initialize lightbox when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  new Lightbox();
});
