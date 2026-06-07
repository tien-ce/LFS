# LFS Automation Scripts

This project automates the compilation and installation of Linux From Scratch (LFS) packages using Python, Bash, and a MySQL database.

## Prerequisites

### 1. Database Setup
Before running the scripts, you must **manually create the database and the required tables** for each chapter. The scripts expect a table structure that tracks the installation state for each package.

**Required Database:**
- Create a database named `lfs_automation` (or as defined in your `.env` file).

**Required Tables:**
- `packages`: Stores general package information (populated by `csv_2_database.py`).
- `Chapter5`, `Chapter6`, etc.: Each chapter must have its own table with a `package_name` and `installed` column to track progress.

### 2. Configuration
Create a `.env` file in the root directory with the following variables:
```env
DB_HOST=localhost
DB_USR=your_username
DB_PWD=your_password
DB_NAME=lfs_automation
```

## Usage

1. **Populate Package Data:** Run `python3 csv_2_database.py` to load package info from `packages.csv`.
2. **Run LFS Build:** Execute `./lfs.sh` to begin the automated build process.
3. **Manual Install:** You can run `python3 packages_install.py <chapter_number> <package_name>` to install a specific package.

## Note on Script Execution
The shell scripts expect scripts to exist in `ChapterX/` directories. If a script is missing or fails, the database will not be updated.
