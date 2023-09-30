**Sterlingcoin**

https://github.com/validierungcc/sterlingcoin-docker

https://sterlingcoin.org/


minimal example docker-compose.yml

     ---
    version: '3.9'
    services:
        sterlingcoin:
            container_name: sterlingcoin
            image: vfvalidierung/sterlingcoin:latest
            restart: unless-stopped
            ports:
                - '11887:11887'
                - '127.0.0.1:11886:11886'
            volumes:
                - 'sterling_data:/sterling/.sterlingcoin'
    volumes:
       sterling_data:

**RPC Access**

    curl --user 'sterlingrpc:<password>' --data-binary '{"jsonrpc":"2.0","id":"curltext","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:11886
