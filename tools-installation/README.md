# Tools Installation — SSAS Fundamentals Course
## For Assmang Pty Ltd Training

---

## 📋 Required Tools

This course requires SQL Server data tools and an SSAS instance. Below are installation guide for each OS.

---

## 1. SQL Server (Database Engine)

### Purpose
Provides the relational database that feeds data into SSAS cubes.

### Recommended Version
- **SQL Server 2019 Standard** or **2022 Standard** (for production use)
- **SQL Server 2019/2022 Developer Edition** (free, suitable for training and development)

### Installation — Windows
```
1. Download SQL Server 2019 Developer Edition from:
   https://www.microsoft.com/en-us/sql-server/sql-server-downloads

2. Run the installer and choose "Basic" or "Custom" installation

3. Select components:
   ✅ Database Engine Services
   ✅ Analysis Services
   ✅ Integration Services
   ✅ Reporting Services (optional)

4. Accept default instance name or specify "SSASDEV"

5. Leave port as default 1433

6. Choose "Mixed Mode" authentication (SQL Server + Windows)
   - SA password: (create a strong password, write it down)

7. Complete installation (may take 15-20 minutes)

8. Verify: 
   Open SQL Server Management Studio (SSMS)
   Connect to: localhost\SSASDEV (or your instance name)
   Should connect successfully
```

### Installation — macOS
```
❌ SQL Server is NOT natively available for macOS.

WORKAROUND OPTIONS:
1. Use Docker for SQL Server on Mac:
   docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourPassword123" \
     -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest
   
2. Use Windows VM (VMware Fusion, Parallels, or VirtualBox)
   - Recommended: 4 GB RAM, 20 GB disk minimum

3. Use Azure SQL Database (cloud-hosted, paid)

⚠️ MOST RECOMMENDED: Windows VM or Docker
   SQL Server Analysis Services requires Windows or Windows containers
```

### Installation — Linux
```
Linux support is limited for SSAS. Options:

1. Docker with SQL Server:
   docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourPassword123" \
     -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest

2. Tabular SSAS (runs on Linux, but complex setup):
   Not recommended for beginners — multidimensional SSAS requires Windows

⚠️ MOST RECOMMENDED: Windows VM, Docker, or cloud (Azure SQL)
   Analysis Services is Windows-native and requires Windows for full functionality
```

---

## 2. SQL Server Management Studio (SSMS)

### Purpose
GUI tool to manage SQL Server databases, create and process cubes.

### Recommended Version
- **SSMS 19.1+** (compatible with SQL Server 2019/2022)

### Installation — Windows
```
1. Download from: https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms

2. Run installer (SSMS-Setup-ENU.exe)

3. Accept default installation path

4. Wait for installation (5-10 minutes)

5. Click "Close" when complete

6. Verify:
   Open SSMS from Start Menu
   Connection dialog should appear
   Server name: localhost\SSASDEV
   Click "Connect"
```

### Installation — macOS
```
❌ SSMS is NOT available for macOS natively.

ALTERNATIVES:
1. Use SSMS in Windows VM (best option)
2. Use Azure Data Studio (cross-platform, but fewer SSAS features)
   Download: https://learn.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio

⚠️ MOST RECOMMENDED: Windows VM with SSMS
```

### Installation — Linux
```
SSMS is not available for Linux.

ALTERNATIVE: Azure Data Studio
   apt-get install azure-data-studio  (Ubuntu/Debian)
   Or download from: https://learn.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio

⚠️ NOTE: Limited SSAS support in Azure Data Studio
   Best option: Use Windows VM
```

---

## 3. SQL Server Data Tools (SSDT) for Visual Studio

### Purpose
IDE for building SSAS Projects, developing cubes, writing MDX, and deploying to Analysis Services.

### Recommended Version
- **Visual Studio Community 2022** + **SSDT for Visual Studio 2022**

### Installation — Windows
```
STEP 1: Install Visual Studio Community
1. Download from: https://visualstudio.microsoft.com/downloads/
2. Run "Visual Studio Community 2022" installer
3. Select "Workloads":
   ✅ Cloud computing (Azure development tools)
   ✅ Data storage and processing

4. Click "Install" (takes 20-30 minutes)

STEP 2: Install SSDT
1. Download SSDT for VS 2022:
   https://learn.microsoft.com/en-us/sql/ssdt/download-sql-server-data-tools-ssdt

2. Run "SSDT-Setup-ENU.exe"

3. Select "Install new SQL Server Data Tools"

4. Complete installation (10-15 minutes)

5. Verify:
   Open Visual Studio Community
   File → New Project
   Search for "Analysis Services"
   Should see: "Analysis Services Multidimensional Project" template
```

### Installation — macOS
```
❌ Visual Studio Community is NOT available for macOS.

⚠️ Mac users MUST use a Windows VM or Docker Windows container
   SSDT requires Visual Studio, which is Windows-only

Option: Use Visual Studio Code + Python/R for development
   But NOT suitable for SSAS cube development in this course
```

### Installation — Linux
```
Visual Studio and SSDT are not available for Linux.

⚠️ Linux users MUST use Windows VM for SSAS development
   Or use cloud-based development in Azure
```

---

## 4. SQL Server Analysis Services (SSAS)

### Purpose
Multi-dimensional OLAP engine for cube creation and querying.

### Installation — Windows (included with SQL Server)
```
SSAS is installed as part of SQL Server installation.

To verify SSAS is running:
1. Open Services (services.msc)
2. Look for "SQL Server Analysis Services"
3. Status should be "Running"
4. If stopped, right-click → Start

To connect in SSMS:
1. Open SSMS
2. Server type: Analysis Services
3. Server name: localhost (or localhost\SSASDEV if named instance)
4. Click "Connect"
```

### Verify SSAS Installation — All OS
```
Once SQL Server + SSDT are installed:
1. Open Visual Studio
2. Create new "Analysis Services Multidimensional Project"
3. Project should create without errors
4. This confirms SSAS is available
```

---

## 5. Recommended — Power BI Desktop (Optional)

### Purpose
End-user reporting tool to connect to SSAS cubes.

### Installation — Windows / macOS / Linux
```
Download: https://powerbi.microsoft.com/en-us/desktop/

Installation steps are straightforward on all platforms.

In course: Used in Day 2 Topic 8 (optional reporting demo)
```

---

## 6. Recommended — Excel (Optional)

### Purpose
Quick-and-easy pivot table and reporting from SSAS cubes.

### Installation
- Windows: Built into Microsoft 365 or standalone
- macOS: Available in Microsoft 365
- Linux: Not available (use LibreOffice as alternative, but no native SSAS support)

---

## 📊 RECOMMENDED SETUP FOR COURSE

### ✅ Windows (Best for full course experience)
```
1. Windows 10/11 (with admin rights)
2. SQL Server 2019 Developer Edition
3. SQL Server Management Studio (SSMS) 19+
4. Visual Studio Community 2022 + SSDT
5. (Optional) Power BI Desktop
6. (Optional) Excel 2021+

Total disk space needed: ~40 GB
Time to complete setup: 60-90 minutes
```

### ✅ macOS (Workaround options)
```
Option A (Recommended): Windows VM
   1. Install VMware Fusion / Parallels / VirtualBox
   2. Install Windows 10/11 in VM (20 GB disk, 4 GB RAM minimum)
   3. Follow Windows setup above inside VM
   
Option B: Docker Windows Container
   1. Install Docker Desktop for Mac
   2. Use Docker image for SQL Server + SSAS
   (More complex, requires Docker knowledge)

Time to complete: 2-3 hours
```

### ✅ Linux (Workaround options)
```
Option A (Recommended): Windows VM
   Same as macOS Option A
   
Option B: Azure SQL Database + cloud SSAS
   Use Microsoft Azure for hosted SQL Server and SSAS
   (Requires Azure subscription and internet)

Time to complete: 2-3 hours
```

---

## ⚠️ Troubleshooting

### SSMS Cannot Connect to SQL Server
```
Solution:
1. Verify SQL Server service is running:
   - Open "Services" (services.msc on Windows)
   - Find "SQL Server (SSASDEV)" or similar
   - Restart if stopped

2. Check server name:
   - Correct: localhost\SSASDEV
   - NOT: localhost (without instance)
   
3. Check firewall:
   - Windows Firewall may block port 1433
   - Add exception for sqlserver.exe
```

### Visual Studio Cannot Find SSAS Project Template
```
Solution:
1. Verify SSDT is installed (not just SQL Server Features)
2. If not installed, download and run SSDT installer
3. Restart Visual Studio after SSDT installation
4. In VS, Check: Tools → Extensions and Updates
   Search for "Analysis Services"
```

### SSAS Service Not Starting
```
Solution:
1. Check Windows Event Viewer for error messages
2. Verify SQL Server license is valid (Developer Edition is free)
3. Check disk space (SSAS needs at least 5 GB free)
4. Restart the service: Services → SQL Server Analysis Services → Restart
```

---

## 📌 Installation Summary Table

| Tool | Windows | macOS | Linux | Recommended |
|------|---------|-------|-------|------------|
| SQL Server | ✅ Native | ⚠️ VM/Docker | ⚠️ Docker | Windows |
| SSMS | ✅ Native | ❌ VM Only | ❌ VM Only | Windows |
| SSDT + VS | ✅ Native | ❌ VM Only | ❌ VM Only | Windows |
| SSAS | ✅ Included | ⚠️ VM | ⚠️ VM | Windows |
| Power BI | ✅ Yes | ✅ Yes | ❌ | Any |
| Excel | ✅ Yes | ✅ Yes | ❌ | Windows/Mac |

---

## 🚀 Quick Start Validation

After installation, run this validation script:

```sql
-- Run in SQL Server Management Studio

-- 1. Verify SQL Server is accessible
SELECT @@VERSION;

-- 2. Verify Analysis Services is running
-- (In SSMS, switch to Analysis Services connection type and connect)
-- If successful, you'll see "Connected to Analysis Services"

-- 3. Create test cube
-- (Covered in Day 1, Topic 4)
```

---

## 📞 Installation Support

If you encounter installation issues:
1. Take note of the exact error message
2. Note your OS and version (Windows 10/11, macOS version, etc.)
3. Contact your training coordinator

---

*Tools Installation Guide — SSAS Fundamentals | Assmang Pty Ltd*

