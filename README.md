# ultra-shambo


## Setting up micropython and esp32  
[Source tutorial](https://lemariva.com/blog/2020/03/tutorial-getting-started-micropython-v20)

### Requirements
- node.js
- python >= 3.6
- vscode

### Micropython 
#### Configure virutal environment

1. `python -m venv .esp-venv`
2. `pip install -r ./esp-requirements.txt`
3. install pymakr extension (you **must** have node.js)

### Esp  
1. Connect the device
2. Check device manager, if it does not look like the screen the go to 2a  
![device manager screeb](esp/device.png "Title")  
2a. Copy "CP210x_Universal_Windows_Driver" (in esp) directory to some place on your computer.    
      Right click the connected device, and click something about updating drivers.  
      Follow the window, choose manual setting and point to the copied directory.  
3. Find out the port (on the screen its COM3)
4. Flash the devices memory and install new firmware (COMx should be your port):   
  turn on venv: for Win `.\.esp-venv\Scripts\activate ` for Linux `source ./.esp-venv/bin/activate`   
  ```python -m esptool --chip esp32 --port COMx erase_flash```   
  ```python -m esptool --chip esp32 --port COMx --baud 460800 write_flash -z 0x1000 esp\esp32-20220618-v1.19.1.bin```   

### Merging  
1. Open pymakr global config (should be optional, project config in pymakr.conf, check only address):  
    set address to your port COMx    
    set autoconnet to false  
    set sync_folder to micropython  

## Development
1. Turn on vscode with pymakr on
2. Develop files in micropython directory
3. Use upload button to upload micropython directory to the esp




## Esp resources
- https://docs.espressif.com/projects/esp-idf/en/latest/esp32/hw-reference/esp32/get-started-devkitc.html
