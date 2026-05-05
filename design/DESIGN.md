# Design System Specification

## 1. Overview & Creative North Star
This design system is built to transform the "SmartCampus Companion" from a utility into a premium editorial experience. Moving beyond the rigid, "boxed-in" feel of standard applications, this system adopts the **Creative North Star: The Scholarly Atelier.**

The interface is treated as a series of curated, layered workspaces. It rejects the "template" look by utilizing intentional asymmetry, expansive negative space, and a sophisticated interplay between deep academic tones and vibrant highlights. The goal is to provide students with a sense of calm authority and modern fluidity.

---

## 2. Colors & Tonal Depth
The color strategy leverages Material 3’s tonal palettes to create hierarchy without visual noise.

### The "No-Line" Rule
To achieve a high-end feel, **1px solid borders are strictly prohibited** for sectioning content. Boundaries must be defined through background color shifts or subtle tonal transitions. Use `surface-container-low` for large section backgrounds resting on a `surface` base.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of fine paper. 
- **Base Layer:** `surface` (#faf8ff)
- **Structural Sections:** `surface-container-low` (#f4f3fa)
- **Interactive Cards:** `surface-container-lowest` (#ffffff) or `surface-container-high` (#e9e7ef) for emphasis.
- **Nesting:** Always place a "lighter" surface on a "darker" background to create a natural lift (e.g., a white card on a light grey section).

### The "Glass & Gradient" Rule
- **Glassmorphism:** Use semi-transparent variants of `surface` (80% opacity) with a `20px` backdrop blur for floating headers and the bottom navigation bar.
- **Signature Gradients:** For primary CTAs and Hero sections, use a subtle linear gradient transitioning from `primary` (#00236f) to `primary_container` (#1e3a8a) at a 135-degree angle. This provides a "soul" to the UI that flat hex codes cannot mimic.

---

## 3. Typography
The system employs a high-contrast pairing of **Public Sans** (for authoritative, geometric headlines) and **Inter** (for high-legibility, accessible body text).

| Role | Font | Size | Weight | Tracking |
| :--- | :--- | :--- | :--- | :--- |
| **Display-LG** | Public Sans | 3.5rem | 700 (Bold) | -0.02em |
| **Headline-SM**| Public Sans | 1.5rem | 600 (Semi) | -0.01em |
| **Title-MD** | Inter | 1.125rem| 500 (Medium)| 0 |
| **Body-LG** | Inter | 1.0rem | 400 (Reg) | 0.01em |
| **Label-MD** | Inter | 0.75rem | 600 (Semi) | 0.05em |

*Director’s Note: Use `display-md` for empty states or welcome screens to create an editorial, magazine-like impact. Ensure all body text remains at a minimum of 14px (`body-md`) for institutional accessibility.*

---

## 4. Elevation & Depth
Depth is achieved through **Tonal Layering** rather than heavy shadows.

- **The Layering Principle:** Place `surface-container-lowest` cards on `surface-container-low` backgrounds to create "soft lift."
- **Ambient Shadows:** For floating elements (FABs, Modals), use extra-diffused shadows.
    - *Shadow Color:* `on-surface` (#1a1b21) at 6% opacity.
    - *Blur:* 24px | *Y-Offset:* 8px.
- **The "Ghost Border" Fallback:** If a container requires a boundary for accessibility (e.g., a search bar), use the `outline-variant` token (#c5c5d3) at **15% opacity**. Never use 100% opaque borders.

---

## 5. Components

### Cards
- **Corner Radius:** `md` (0.75rem / 12px).
- **Styling:** No borders. Use `surface-container-lowest` fill.
- **Spacing:** Minimum 16px internal padding. 
- **Separation:** Forbid the use of divider lines. Separate content using 24px of vertical white space or a change in typography weight.

### Buttons
- **Primary:** Full-rounded (`full`). Gradient fill (`primary` to `primary_container`). White text.
- **Secondary:** Tonal fill using `secondary_container` (#d0d8ff).
- **Tertiary/Text:** Transparent background with `primary` text. No container.

### Input Fields
- **Container:** Filled style using `surface-container-high`.
- **Corner Radius:** `sm` (0.25rem) for the top corners, with a 2px `primary` indicator line at the bottom only upon focus.
- **Validation:** 
    - *Error:* `error` (#ba1a1a) text and icon.
    - *Success:* `tertiary_fixed_dim` (#ffb95f) for a sophisticated, non-cliché "amber" success state.

### Bottom Navigation
- **Style:** 4-item layout.
- **Effect:** Semi-transparent `surface` with backdrop blur (Glassmorphism).
- **Active State:** A soft "glow" behind the icon using `primary_fixed_dim` at 30% opacity, rather than a hard-edged pill.

### App States & Feedback
- **Offline Banner:** Use a full-width `tertiary_container` (#5c3800) bar at the top of the viewport. Text color: `on_tertiary_container`.
- **Loading (Skeletons):** Use a soft pulse animation. Base: `surface-container-high`. Highlight: `surface-variant`.
- **Badges:** Use `tertiary` (Amber) for high-urgency notifications (e.g., "Class Cancelled") to contrast against the Deep University Blue.

---

## 6. Do's and Don'ts

### Do
- **Do** use the 8px baseline grid to ensure all margins and paddings are multiples of 8.
- **Do** prioritize white space. If an interface feels cluttered, increase the padding rather than adding a divider.
- **Do** use `headline-sm` for section titles to maintain an editorial hierarchy.

### Don't
- **Don't** use pure black (#000000). Always use `on-surface` (#1a1b21) for text to maintain tonal softness.
- **Don't** stack more than three levels of surface nesting to avoid visual "mush."
- **Don't** use standard Material 3 shadows; they are too heavy for this premium aesthetic. Stick to the ambient shadow spec.