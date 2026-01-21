# Target Deals App

An iOS app built to replace a rough proof-of-concept with a clean, production-ready implementation.  
The focus is on architecture, performance, and real-world user experience.

---

## Overview

The app allows users to browse Target deals, view detailed product information.

---

## Features

- Deal list with images, prices, and availability  
- Deal detail screen with full product information  
- Pull-to-refresh, loading, empty, and error states  
- Localization ready

---

## Technical Highlights

- **Clean Architecture** with clear separation of concerns based on MVVM
- **UIKit + SwiftUI**: UIKit for the deal list, SwiftUI for the detail screen  
- **Async/Await & Swift Concurrency** for asynchronous operations  
- **Combine** for reactive state updates  
- **Coordinator pattern** for navigation flow  
- **Unit tests** covering core business logic  
- **No third-party dependencies** 

---

## Future Improvements

Given more time, the following enhancements could be added:

- Pagination or predictive loading for large deal lists
- Additional features like search/filtering can be supported
- More advanced offline support 
- Improved accessibility
- CI/CD Integrations

---

## Notes

This project was built with production standards in mind, prioritizing maintainability, testability, and performance while keeping it simple.
