Social Media App in Bash
---
A basic social media application with a client-server architecture written in Bash. The purpose of the app is to show and explore concurrency, locking, semaphores and other related concepts.

Architecture/Design
---
The system is based on a client-server interaction described below:

Server: 
* The server handles all of the management of users and their interactions. Once started the server runs in an infinite loop and listens on the ``server.pipe`` for messages from clients. 
* Once it reads a request from the pipe it performs some validation on the input and then executes the requested action if possible by calling the relevant basic script (``create.sh``, ``show.sh``, ``add.sh``, or ``post.sh``) with the arguments it has received. Rather than printing out any output from these actions, it redirects both STDOUT and STDERR to the client's pipe which is called ``clientId.pipe``. Each client must send a client ID  to the server so that the server knows which pipe to send the output back to. 
* Multiple clients can interact with the server concurrently and to facilitate this the server runs any valid requests it receives in the background. 
* The server and the scripts that it calls also have locking mechanisms implemented with semaphores (``P.sh`` and ``V.sh``) to prevent inconsistencies when multiple clients wish to interact with a shared resource. For example, if two clients wish to post on a user's wall, then only one of them will be granted exclusive access to write on the wall at any point in time to ensure that the two clients' messages do not get interleaved together. Similarly, a lock is placed on a user's friend list when a client is writing to it so that no other client can write to the same file at the same time and cause inconsistencies.

Client: 
* The client is how a user interacts with the social media system. Users call ``client.sh`` with an ID, the action they wish to perform, and any additional required arguments. 
* The ``client.sh`` file reads the command line arguments that are passed to it and, rather than executing the relevant script to complete the basic action itself, it uses ``echo`` to send the request with the Client ID and the relevant arguments onto the server's pipe. It then waits for a response to its own pipe, ``clientId.pipe`` and prints it to STDOUT and STDERR when it receives one. Note that in my design the client exits after completing each request so a new call is required to ``client.sh`` for each request. An alternative design could be to allow one call to ``client.sh`` to receive multiple requests before terminating. 
* The client also performs validation of the input it receives to ensure that it is not sending invalid requests to the server. 
* Any client can shutdown the server at any time by issuing a ``shutdown`` request. A client cannot perform any actions if the server is not running.

Functionality
---
* Create users 
* Track friends 
* Users can interact with each other by posting on each other's walls and viewing the outcome. 
* Performs simple validation such as checking whether a user is permitted to post on another user's wall or whether a user is already friends with another
* Facilitates many users interacting with the system concurrently and handle any issues associated with this to prevent data corruption or inconsistencies
