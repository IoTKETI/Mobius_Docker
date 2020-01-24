# Mobius_Docker Installation

**1. Download docker**

    sudo apt-get install docker.io

**2. Download docker-compose**

    sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

**3. Change the permission to use docker-compose**
    
    sudo chmod +x /usr/local/bin/docker-compose

**4. Download the docker-compose "yml" file of Mobius**

    git clone https://github.com/IoTKETI/Mobius_Docker.git
    
    cd Mobius_Docker

**5. Download the latest Mobius source code**

    git clone https://github.com/IoTKETI/Mobius.git
    
    cd Mobius

**6. Copy mobiusdb.sql to docker-entrypoint-initdb.d directory**

    mkdir sql
    
    cp ./mobius/mobiusdb.sql ./sql/mobiusdb.sql
    
**7. Download the essential libraries required to run Mobius**

    sudo apt-get install npm
    
    npm install
    
    cd ..

**8. Run docker-compose**

    sudo docker-compose up
    
* Docker-compose If forcibly terminated, enter the "sudo docker-compose down" command mandatory input


# Snapshot of normal running Mobius docker 
![정상동작 화면](./img/성공화면.PNG)


# Docker-compose configuration details




 DB
 
    image: mysql:5.7    # Import the mysql docker image stored in the Docker-Hub.
    environment:        # This is the mysql environment variable setting.
      MYSQL_ROOT_PASSWORD: dksdlfduq2
      MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
      MYSQL_DATABASE: mobiusdb
    ports:    # Port matching of HOST Port and Docker is required.  "HOST:Docker-container" 
      - "3306:3306"
    network_mode: "host"  # It operates in the same network environment as the host for easy use.
    volumes:              # Get the required libraries from the Host. The mobiusdb.sql file is prepared in this path.
      - ./Mobius/sql:/docker-entrypoint-initdb.d
    healthcheck:          # It is a function of Docker-compose to check whether the software is working or not.
            test: ["CMD", "mysqladmin" ,"ping", "-h", "localhost"]
            timeout: 20s
            retries: 10
            
 Mobius			
 
    image: "node:7.6"
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

* **JongGwan An** - *Initial work* - [Cftn] (https://github.com/Cftn) (kman3212@gmail.co.kr, kman3212@keti.re.kr)


