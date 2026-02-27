# 📱 Offline Village Issue & Item Tracker

An **offline-first Flutter application** designed for rural and low-connectivity areas.  
This app allows users to report village issues and track essential items even without internet access.  
All data is stored locally and automatically synced with the government server once connectivity is restored.

---

##  Features

### Issue Reporting (Offline)
- Capture issue details:
  - 🏘 Village Name
  - 📍 Area Name
  - 📝 Description
  - ⚠ Priority Level
  - 📅 Date
  - 📷 Issue Image
  - 🌍 GPS Coordinates
- Works fully offline
- Data stored securely in local database (Hive)

---

### Item Tracking (Offline)
- Add and manage essential village inventory
- Track item quantities
- Store stock updates locally
- Ready for sync when internet returns

---
  Smart Sync System
- Detects internet availability
- Automatically syncs pending data with government server
- Prevents duplicate submissions
- Ensures reliable data delivery

---

### User Notification System
- Notifies users when:
  - Issue is successfully synced
  - Issue status is updated
  - Action is taken by authorities

---

## 🛠 Tech Stack

- **Flutter**
- **Hive (Local Database)**
- **Geolocator (GPS Coordinates)**
- **Image Picker (Issue Photos)**
- **Connectivity Handling**
- REST API integration (for sync)

---

## 🏗 Architecture
