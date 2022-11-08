# ultra-shambo


## Setting up micropython and esp32  
[Source tutorial](https://lemariva.com/blog/2020/03/tutorial-getting-started-micropython-v20)
### Micropython  
1. Only at first run: `python -m venv .esp-venv`
2. for Win `.\.esp-venv\Scripts\activate ` for Linux `source ./.esp-venv/bin/activate`
3. Only at first run: `pip install -r ./esp-requirements.txt`

### Esp  
1. Connect the device
2. Check device manager, if it does not look like the screen the go to 2a  
![device manager screeb](esp/device.png "Title")  
2a. Copy "CP210x_Universal_Windows_Driver" (in esp) directory to some place on your computer.    
      Right click the connected device, and click something about updating drivers.  
      Follow the window, choose manual setting and point to the copied directory.  
3. Find out the port (on the screen its COM3)
4. Flash the devices memory and install new firmware (COMx should be your port):   
  ```python -m esptool --chip esp32 --port COMx erase_flash```   
  ```python -m esptool --chip esp32 --port COMx --baud 460800 write_flash -z 0x1000 esp\esp32-20220618-v1.19.1.bin```   

### Merging  
1. install pymakr extension (you **must** have node.js)
2. Open pymakr global config (should be optional, project config in pymakr.conf, check only address):  
    set address to your port COMx    
    set autoconnet to false  
    set sync_folder to micropython  
3. Use upload button to upload micropython directory to the esp



## Esp resources
- https://docs.espressif.com/projects/esp-idf/en/latest/esp32/hw-reference/esp32/get-started-devkitc.html
