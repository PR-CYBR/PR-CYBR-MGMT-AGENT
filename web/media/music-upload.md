# Instructions for Uploading Music to the `media/` Directory

## Step-by-Step Instructions for Uploading Music

### 1. Access the `media/` Directory

- **Locate the Directory**: 
  - The `media/` directory should be part of your project structure. If it doesn't exist, create it in the root of your project or within a designated assets folder.

- **Permissions**:
  - Ensure you have the necessary permissions to read and write files in this directory. If you're using a server, you might need to adjust file permissions or ownership.

### 2. Prepare Your Music Files

- **Supported Formats and Size Limit**:
  - Ensure your music files are in a supported format, such as MP3, WAV, or OGG. Check the music player’s documentation for supported formats.
  - Note that there is a 25MB size limit for files uploaded to GitHub. Ensure your music files do not exceed this limit to avoid upload issues.

- **File Naming**:
  - Use clear and consistent naming conventions for your files. Avoid spaces and special characters to prevent issues with file paths.

### 3. Upload Music Files

- **Manual Upload**:
  - **Local Development**: Simply drag and drop your music files into the `media/` directory using your file explorer or terminal.
  - **Remote Server**: Use a file transfer protocol (FTP) client like FileZilla, or secure copy (SCP) via the command line to upload files to the server.

  ```bash
  # Example using SCP
  scp /path/to/local/musicfile.mp3 user@server:/path/to/project/media/
  ```