# Ken Zillig Personal Website

## File Structure

```
kenzillig-site/
├── index.html          ← Homepage
├── research.html       ← Research projects
├── publications.html   ← Full publications list
├── cv.html             ← Curriculum vitae
├── contact.html        ← Contact form
├── css/
│   └── style.css       ← All styles (heavily commented)
├── js/
│   └── main.js         ← Navigation + animations
└── images/             ← PUT YOUR IMAGES HERE
    ├── hero-bg.jpg         (full-screen hero background)
    ├── about-photo.jpg     (your headshot)
    ├── research-salmon.jpg
    ├── research-antarctica.jpg
    ├── research-coregonid.jpg
    ├── research-hydropower.jpg
    ├── research-rationing.jpg
    └── research-burst.jpg
```

## Quick Edits

**Update your email:** Search for `YOUR_EMAIL@umn.edu` in contact.html and replace it.

**Update your bio:** Open index.html, find the comment `EDIT YOUR BIO HERE`, and change the text.

**Add a publication:** Open publications.html, copy a `.pub-entry` block, paste at the top of the right year section, update text.

**Add a research project:** Open research.html, copy a `.research-section` block, paste it, update text and image.

**Add images:** Drop jpg/png files into the `images/` folder using the filenames listed above.

## Setting Up Formspree (Contact Form)

1. Go to https://formspree.io — create a free account
2. Create a new form and enter your email
3. Copy your form ID (looks like `xyzabcde`)
4. Open contact.html, find `YOUR_FORMSPREE_ID`, replace with your ID

## Deploying to GitHub Pages

1. Push all these files to your `kenzillig.github.io` repository
2. Replace any existing files — your domain stays the same
3. Site will be live at https://kenzillig.github.io within a few minutes
