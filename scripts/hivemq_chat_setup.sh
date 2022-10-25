HIVEMQ_VERSION=$1
STORAGE_ACCESS_KEY=$2
STORAGE_CONTAINER_NAME=$3

HIVEMQ_DOWNLOAD_LINK="https://www.hivemq.com/releases/hivemq-${HIVEMQ_VERSION}.zip"

EXTENSION_DOWNLOAD_LINK="https://github.com/WahidNasri/hivemq-chat-extension/blob/main/ChatExtension-1.0-SNAPSHOT-distribution.zip"

sudo apt-get update -y
sudo apt-get install -y openjdk-11-jdk
sudo apt-get -y install unzip

# Install HiveMQ 
cd /opt 
sudo wget --content-disposition $HIVEMQ_DOWNLOAD_LINK
sudo unzip "hivemq-${HIVEMQ_VERSION}.zip"
sudo ln -s "/opt/hivemq-${HIVEMQ_VERSION}" /opt/hivemq
sudo useradd -d /opt/hivemq hivemq
sudo chown -R hivemq:hivemq "/opt/hivemq-${HIVEMQ_VERSION}"
sudo chown -R hivemq:hivemq /opt/hivemq
cd /opt/hivemq
sudo chmod +x ./bin/run.sh
sudo cp /opt/hivemq/bin/init-script/hivemq.service /etc/systemd/system/hivemq.service

echo "<?xml version=\"1.0\"?>
<hivemq>

    <listeners>
        <tcp-listener>
            <port>1883</port>
            <bind-address>0.0.0.0</bind-address>
        </tcp-listener>
    </listeners>

    <cluster>
        <enabled>true</enabled>

        <transport>
            <tcp>
                <bind-address>0.0.0.0</bind-address>
                <bind-port>7800</bind-port>
            </tcp>
        </transport>

        <discovery>
            <extension/>
        </discovery>

    </cluster>

     <control-center>
        <enabled>true</enabled>
        <listeners>
            <http>
                <port>8080</port>
                <bind-address>0.0.0.0</bind-address>
            </http>
        </listeners>
    </control-center>

</hivemq>" | sudo tee /opt/hivemq/conf/config.xml

# Install extension

cd /opt/hivemq/extensions
sudo wget --content-disposition $EXTENSION_DOWNLOAD_LINK -O azure-extension.zip
jar xvf azure-extension.zip

sudo systemctl enable hivemq
sudo systemctl start hivemq
