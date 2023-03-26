# Mobius_Docker Installation

**1. Download Mobius_Docker from KETI's git repository**

    sudo git clone https://github.com/IoTKETI/Mobius_Docker.git
    cd Mobius_Docker

**2. Execute "install.sh"**

    sudo ./install.sh
    
**3. Execute "run.sh"**

    sudo ./run.sh
    
**4. Test using cURL**

    sudo ./test.sh
  
  
**You can follows below commands for each objective**
    
    Stop mobius docker containers 
    "sudo ./stop.sh"
    
    Remove mobius docker containers
    "sudo ./remove.sh"

    Check status of mobius docker containers
    "sudo ./status.sh"

    Show logs of mobius docker containers
    "sudo ./logs.sh"


# Snapshot of normal running Mobius docker 

In the snapshot, left console shows response of "Retrieve CES Resource" and right console describes request of "Retreive CSE Resoruce" respectively.

![정상동작 화면](https://user-images.githubusercontent.com/29790334/102583698-803f1280-4148-11eb-8fe4-878bda1df7a2.png)
![정상동작 화면](https://user-images.githubusercontent.com/29790334/102583766-9c42b400-4148-11eb-8d17-7aac7a91c216.png)


# Docker-compose configuration details

 DB
 
    image: mysql:latest    # Import the mysql docker image stored in the Docker-Hub.
    environment:        # This is the mysql environment variable setting.
      MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
      MYSQL_ROOT_PASSWORD: "dksdlfduq2"
      MYSQL_DATABASE: "mobiusdb"
    ports:    # Port matching of HOST Port and Docker is required.  "HOST:Docker-container" 
      - "3306:3306"
    network_mode: "host"  # It operates in the same network environment as the host for easy use.
    volumes:              # Get the required libraries from the Host. The mobiusdb.sql file is prepared in this path.
      - ./Mobius/sql:/docker-entrypoint-initdb.d
    healthcheck:          # It is a function of Docker-compose to check whether the software is working or not.
            test: ["CMD", "mysqladmin" , "--password=dksdlfduq2", "ping"]
            interval: 20s
            timeout: 20s
            retries: 10
            
 Mobius			
 
    image: "node:14.5.2"
    working_dir: /home/node/app   # Sets the virtual image directory of the Nodejs-based Mobius.
    environment:
      - NODE_ENV=production
    volumes:                   # Import mobius source code from the host into the virtual image directory.
      - ./Mobius:/home/node/app
    network_mode: "host"
    expose:
      - "8081"
    command: "node mobius"  # When the Docker preference is complete, Mobius runs up.
    depends_on:             # After Mysql is running, Mobius will work. If this is not taken into consideration, it will not execute normally due to delay with DB.
            db:
                condition: service_healthy
 MQTT
 
    image: eclipse-mosquitto:latest  # Import the mosquitto (MQTT Tool) image stored in the Docker-Hub.
    ports:
      - 1883:1883
    network_mode: "host"
    volumes:
      - ./etc/mosquitto:/etc/mosquitto:ro
      - ./var/log/mosquitto:/var/log/mosquitto:rw
    depends_on:		    # Mosquitto will work after mysql is running. If this is not taken into consideration, the delay with Mobius will not work properly.
            db:
                condition: service_healthy


## Authors

* **JongGwan An** - *Initial work* - [Cftn] (https://github.com/Cftn) (jg.an@keti.re.kr, jg.an.1182@gmail.com)


