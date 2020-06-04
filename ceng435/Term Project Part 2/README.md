> e2237824 Ahmet Kürşad Şaşmaz
> e2264661 Ali Şen

# CENG435 Term Project Part 2

# HOW TO RUN

## CREATE CONFIG FILE FOR SSH CONNECTIONS
- Create a file that is named as "config"
```
touch config
```
- Open it with vim
```
vim config
```
- Paste the code below and fill proper parameters
```
Host s
	HostName [HostName]
	user [userName]
	Port [sPort]
	IdentityFile [identityFilePath]
Host r1
	HostName [HostName]
	user [userName]
	Port [r1Port]
	IdentityFile [identityFilePath]
Host r2
	HostName [HostName]
	user [userName]
	Port [r2Port]
	IdentityFile [identityFilePath]
Host r3
	HostName [HostName]
	user [userName]
	Port 2[r3Port]
	IdentityFile [identityFilePath]
Host d
	HostName [HostName]
	user [userName]
	Port [dPort]
	IdentityFile [identityFilePath]

```
- Exit vim
- Move it to the ".ssh" folder
```
mv config ~/.ssh
```

## GIVE PROPER PERMISSIONS

```
chmod +x *.sh
```

## SENDING THE FILES
- To send the proper files to the proper nodes
- Execute this
```
./sendFiles.sh [s|r1|r2|r3|d|all]
```
- If you want to send proper files to the specific node, just give node name as parameter
- If you want to send proper files to all nodes, just give "all" as parameter

## CONFIGURING THE LINKS
- To configure proper links for specific experiment
- and specific loss percentage
- Execute this
```
./configureLinks.sh [experimentNo] [configureNo]
```
- For experiment 1 give "1" as experimentNo parameter
- For experiment 2 give "2" as experimentNo parameter

- For 5% loss percentage give "1" as configureNo parameter
- For 15% loss percentage give "2" as configureNo parameter
- For 38% loss percentage give "3" as configureNo parameter

## UP THE NODES
- To run proper script in a node
- For any router execute this
```
./up.sh [r1|r2|r3]
```
- Just give the router node name as parameter
- 
- For source node execute this
```
./up.sh s [experimentNo] [configureNo] [experimentTimes]
```
- For experiment 1 give "1" as experimentNo parameter
- For experiment 2 give "2" as experimentNo parameter

- For 5% loss percentage give "1" as configureNo parameter
- For 15% loss percentage give "2" as configureNo parameter
- For 38% loss percentage give "3" as configureNo parameter

- To set how many repeats will be done for specific experiment, give repeat number as experimentTimes parameter

- For destination node execute this
```
./up.sh d [experimentNo] [experimentTimes]
```
- For experiment 1 give "1" as experimentNo parameter
- For experiment 2 give "2" as experimentNo parameter

- To set how many repeats will be done for specific experiment, give repeat number as experimentTimes parameter

## DOWN THE NODES
- Source (s) and Destination (d) terminates
- automatically after experiments finished. However,
- routers are always alive. In case of emergency or
- 
- To terminate proper script in a node
- Execute this
```
./down.sh [s|r1|r2|r3|d|experiment|routers|all]
```
- If you want to terminate specific node, just give node name as parameter
- If you want to terminate s and d, just give "experiment" as parameter
- If you want to terminate router nodes, just give "routers" as parameter
- If you want to terminate all nodes, just give "all" as parameter

## GETTING EXPERIMENT RESULTS
- To get the results after experiment done
- Execute this
```
./getResults.sh
```
- This script copies "results.txt" from source "s" node to local as "filledResults.txt"