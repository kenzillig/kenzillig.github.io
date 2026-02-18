/* ================================================================
   MAIN JAVASCRIPT — Ken Zillig Website
   
   This file handles:
   - Navbar background change on scroll
   - Mobile menu toggle
   - Scroll-triggered fade-in animations
   
   You generally won't need to edit this file unless you want to
   change animation behavior.
================================================================ */

document.addEventListener('DOMContentLoaded', function () {

  // ---- NAVBAR: Add background when user scrolls down ----
  const navbar = document.getElementById('navbar');

  function updateNavbar() {
    if (window.scrollY > 60) {
      navbar.classList.add('scrolled');
    } else {
      navbar.classList.remove('scrolled');
    }
  }

  window.addEventListener('scroll', updateNavbar);
  updateNavbar(); // Run once on load in case page is already scrolled

  // ---- MOBILE MENU TOGGLE ----
  const toggle = document.querySelector('.nav-toggle');
  const navLinks = document.querySelector('.nav-links');

  if (toggle && navLinks) {
    toggle.addEventListener('click', function () {
      navLinks.classList.toggle('open');
    });

    // Close menu when a link is clicked
    navLinks.querySelectorAll('a').forEach(function (link) {
      link.addEventListener('click', function () {
        navLinks.classList.remove('open');
      });
    });
  }

  // ---- SCROLL FADE-IN ANIMATIONS ----
  // Elements with class "fade-in" will animate when they enter the viewport.
  // This uses the Intersection Observer API (works in all modern browsers).
  
  // Add fade-in styles
  const style = document.createElement('style');
  style.textContent = `
    .fade-in {
      opacity: 0;
      transform: translateY(24px);
      transition: opacity 0.6s ease, transform 0.6s ease;
    }
    .fade-in.visible {
      opacity: 1;
      transform: none;
    }
  `;
  document.head.appendChild(style);

  // Automatically apply fade-in to major content sections
  const fadeTargets = document.querySelectorAll(
    '.research-card, .pub-item, .pub-entry, .cv-entry, .research-section-text, .about-text, .stat'
  );

  fadeTargets.forEach(function (el) {
    el.classList.add('fade-in');
  });

  // Watch for elements entering the viewport
  const observer = new IntersectionObserver(
    function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          observer.unobserve(entry.target); // Only animate once
        }
      });
    },
    { threshold: 0.1, rootMargin: '0px 0px -40px 0px' }
  );

  fadeTargets.forEach(function (el) {
    observer.observe(el);
  });

  // ---- ACTIVE NAV LINK ----
  // Highlight the correct nav link based on current page
  const currentPage = window.location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.nav-links a').forEach(function (link) {
    const href = link.getAttribute('href');
    if (href === currentPage) {
      link.classList.add('active');
    }
  });

});
