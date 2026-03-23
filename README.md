# HealthDashboard — iOS App

A feature-rich health analytics dashboard iOS application built as a company assignment, showcasing data visualisation, custom UI components, and clean MVVM architecture.

---

## Screenshots

> Screen recording is provided in the mail.

---

## Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture pattern:

```
HealthDashboard/
├── App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
└── Modules/
    └── Dashboard/
        ├── View/
        │   ├── DashboardViewController.swift (.xib)
        │   ├── MainTabBarController.swift
        │   └── Cells/
        │       ├── StabilitySummaryCell (.swift + .xib)
        │       ├── CycleTrendsCell (.swift + .xib)
        │       ├── BodyTrendsCell (.swift + .xib)
        │       ├── BodySignalsCell (.swift + .xib)
        │       ├── LifestyleImpactCell (.swift + .xib)
        │       └── HeatmapItemCell (.swift + .xib)
        ├── ViewModel/
        │   └── DashboardViewModel.swift
        └── Components/
            ├── StabilityChartView.swift
            ├── CycleTrendsChartView.swift
            ├── BodyMetabolicChartView.swift
            └── SymptomTrendsChartView.swift
```

---

## Features Implemented

### 1. Stability Summary
- Custom area chart built with **DGCharts** (via SPM)
- Two layered fill bands showing upper and lower stability ranges
- Highlight dot at current month (Mar) with dashed vertical line
- Custom tooltip bubble with tail ("Stability Improving")
- Bold label for current month on X axis
- Y axis formatted as day values (24d, 28d, 32d, 36d)

### 2. Cycle Trends
- Fully **custom UIKit chart** — no third-party library used
- Vertical pill-shaped bars with 4 colour segments:
  - Purple (top — luteal phase)
  - Green (ovulation — with custom icon `imgCycleGraph1`)
  - Light purple (fertile phase)
  - Pink (period — with custom icon `imgCycleGraph2`)
- **Horizontal scroll** with left/right arrow buttons
- Total day count label on top of each bar
- Month labels at the bottom
- Data-driven segment heights

### 3. Body & Metabolic Trends
- Line chart with smooth cubic bezier curve using **DGCharts**
- Filled area under the line
- Dot markers on each data point
- **Monthly / Weekly toggle** (UISegmentedControl)
- Toggle switches chart data dynamically without reloading the cell
- Dashed grid lines on Y axis

### 4. Body Signals — Symptom Trends (Donut Chart)
- Built with **Apple Swift Charts** (`SectorMark`, iOS 17+)
- Wrapped in `UIHostingController` for UIKit integration
- 4 segments: Mood, Bloating, Fatigue, Acne
- White pill labels with shadow positioned outside the ring
- Large inner radius for a clean donut look
- Gap between segments (`angularInset`)
- Center text overlay ("Symptom Trends")

### 5. Lifestyle Impact — Correlation Heatmap
- **UICollectionView-based heatmap** grid
- Row label as the first item in each section (`HeatmapLabelCell` — pure code, no XIB)
- Coloured boxes with alpha intensity representing correlation strength
- Gray boxes for zero/no correlation
- Dropdown selector (UIAlertController action sheet) for period selection (1–12 months)
- Powered by `DashboardViewModel` — data passed via `configure(data:)`

### 6. Custom Tab Bar
- Fully custom `CustomTabBarView` — system `UITabBar` hidden entirely
- 3 tabs grouped inside a **glass-effect pill** (UIBlurEffect + white 20% fill)
- Separate **+ button** as a floating circle on the right
- Tab icons stacked above labels using `UIStackView` inside each button
- **Insights tab selected by default**
- Unimplemented tabs (Home, Track, +) show a "Coming Soon" alert
- Smooth tab switching

### 7. Radial Glow Gradient Background
- `CAGradientLayer` with `.radial` type applied to a background view
- Pink glow (`Color_E99597`) positioned in the top-left of the screen
- Green glow (`Color_6E8C82`) used on card views (e.g., Stability Summary)
- Gradient redrawn in `viewDidLayoutSubviews` to handle all screen sizes

---

## 🎨 Design System

### Colors (Asset Catalog)
| Asset Name | Hex | Usage |
|---|---|---|
| `Color_000000` | #000000 | Primary text |
| `Color_696770` | #696770 | Secondary text, icons |
| `Color_E99597` | #E99597 | Pink glow, period segment |
| `Color_6E8C82` | #6E8C82 | Green glow, ovulation segment |
| `Color_B4A8DA` | #B4A8DA | Purple, cycle bar segments |
| `Color_F5FAF9` | #F5FAF9 | Screen background |
| `Color_F7F6F6` | #F7F6F6 | Dropdown background |

### Typography
Custom font **DM Sans** integrated via Info.plist:
- `DMSans-Regular`
- `DMSans-Medium`
- `DMSans-SemiBold`
- `DMSans-Bold`
- `DMSans-Light`

---

## 📦 Dependencies

| Library | Version | Integration | Usage |
|---|---|---|---|
| **DGCharts** | Latest | Swift Package Manager | Stability Summary, Body & Metabolic charts |
| **Swift Charts** | Native (iOS 17+) | Built-in | Symptom Trends donut chart |

### SPM Package URL
```
https://github.com/ChartsOrg/Charts
```

---

## 🔧 Setup & Run

1. Clone the repository:
```bash
git clone https://github.com/yourusername/HealthDashboard.git
```

2. Open the project:
```bash
open HealthDashboard/HealthDashboard.xcodeproj
```

3. DGCharts will be resolved automatically via Swift Package Manager on first build.

4. Select a simulator or device and press **⌘R** to run.

---

## 📋 Requirements

| Requirement | Version |
|---|---|
| iOS | 17.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |
| Device | iPhone (any size) |

---

## 📁 Key Files Reference

| File | Purpose |
|---|---|
| `DashboardViewController.swift` | Main screen — UITableView with 5 sections |
| `DashboardViewModel.swift` | Data layer — correlation data, section enums |
| `MainTabBarController.swift` | Custom tab bar — glass pill + floating + button |
| `StabilityChartView.swift` | Pure UIKit area chart with tooltip |
| `CycleTrendsChartView.swift` | Custom scrollable pill bar chart |
| `BodyMetabolicChartView.swift` | DGCharts line chart with toggle |
| `SymptomTrendsChartView.swift` | SwiftUI donut chart wrapped in UIKit |
| `LifestyleImpactCell.swift` | CollectionView heatmap grid |

---

## 🎥 Demo Video

> https://drive.google.com/file/d/1dIRsqX9GIhnoOM_dRdfXo1UuMyd0zjSW/view?usp=sharing

---

## 👨‍💻 Developer

**Sarvesh Prabhu**  
iOS Developer  
Built: March 2026
