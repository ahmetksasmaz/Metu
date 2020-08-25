package ceng.ceng351.labdb;

import java.util.Vector;



public class LabDB {
    
    private Vector hashTable;
    private int globalDepth;
    private int bucketSize;
    private int modula;
    
    public LabDB(int bucketSize) {
        this.globalDepth = 1;
        this.modula = 2;
        this.bucketSize = bucketSize;
        this.hashTable = new Vector();
        Vector emptyBucket1 = new Vector();
        Vector emptyBucket2 = new Vector();
        emptyBucket1.add(1);
        emptyBucket2.add(1);
        this.hashTable.add(emptyBucket1);
        this.hashTable.add(emptyBucket2);
    }

    public void enter(String studentID) {
        int id = Integer.parseInt(studentID.substring(1));
        int remain = id % this.modula;
        Vector bucket = (Vector)this.hashTable.get(remain);

        if (search(studentID) == "-1"){
            bucket.add(studentID);
            if(bucket.size() > this.bucketSize+1){
                // EXTEND!!!
                Vector newBucket1 = new Vector();
                Vector newBucket2 = new Vector();
                newBucket1.add((int)bucket.get(0)+1);
                newBucket2.add((int)bucket.get(0)+1);
                int modula = (int)Math.pow(2, (int)bucket.get(0)+1);
                int little = remain % (modula/2);
                int size = bucket.size();
                for(int i = 1; i < size; i++){
                    id = Integer.parseInt(((String)bucket.get(i)).substring(1));
                    if(id % modula == little){
                        newBucket1.add(bucket.get(i));
                    }
                    else if (id % modula == (modula/2 + little)){
                        newBucket2.add(bucket.get(i));
                    }
                }
                if((int)bucket.get(0) >= this.globalDepth){
                    this.globalDepth++;
                    this.modula *= 2;
                    this.hashTable.setSize(this.modula);
                    int oldmodula = this.modula/2;
                    for(int i = oldmodula; i < this.modula; i++){
                        this.hashTable.set(i, this.hashTable.get(i-oldmodula));
                    }
                }
                
                int smallindexes = little;
                int bigindexes = (modula/2) + little;
                int bigmodula = (int)Math.pow(2, (int)bucket.get(0)+1);
                
                for(int i = 0; i < this.modula; i++){
                    if(i % bigmodula == smallindexes){
                        this.hashTable.set(i, newBucket1);
                    }
                    else if(i % bigmodula == bigindexes){
                        this.hashTable.set(i, newBucket2);
                    }
                }
                if(newBucket1.size() == 1 || newBucket2.size() == 1){
                    leave(studentID);
                    enter(studentID);
                }
            }
        }
    }

    public void leave(String studentID) {
        int id = Integer.parseInt(studentID.substring(1));
        int remain = id % this.modula;
        Vector bucket = (Vector)this.hashTable.get(remain);
        bucket.remove(studentID);
        if(bucket.size() == 1){
            // SHRINK!!!
            int findBuddy = 0;
            int littlemodulax = (int)bucket.get(0)-1;
            int littlemodula = (int)Math.pow(2, littlemodulax);
            int littleremain = remain % littlemodula;
            for(int i = 0; i < this.modula; i++){
                if(i % littlemodula == littleremain){
                    if(i != remain){
                        if((int)((Vector)this.hashTable.get(i)).get(0) == littlemodulax+1){
                            findBuddy = i;
                            break;
                        }
                    }
                }
            }
            for(int i = 0; i < this.modula; i++){
                if(i % littlemodula == littleremain){
                    if((int)((Vector)this.hashTable.get(i)).get(0) == littlemodulax+1){
                        this.hashTable.set(i,this.hashTable.get(findBuddy));
                    }
                }
            }
            int localDepth = (int)((Vector)this.hashTable.get(findBuddy)).get(0);
            if(localDepth != 1 && ((Vector)this.hashTable.get(findBuddy)).size() > 1){
                ((Vector)this.hashTable.get(findBuddy)).set(0, localDepth-1);
            }
            int maxlocalDepth = 0;
            boolean istheremax = false;
            while((maxlocalDepth < this.globalDepth || istheremax == false) && this.globalDepth != 1){
                maxlocalDepth = 0;
                istheremax = false;
                for(int k = 0; k < this.modula; k++){
                    int lD = (int)((Vector)this.hashTable.get(k)).get(0);
                    if(maxlocalDepth < lD){
                        maxlocalDepth = lD;
                    }
                }
                if(maxlocalDepth < this.globalDepth){
                    this.globalDepth--;
                    this.modula /= 2;
                    this.hashTable.setSize(this.modula);
                }
                for(int k = 0; k < this.modula; k++){
                    Vector curr = (Vector)this.hashTable.get(k);
                    if((int)curr.get(0) == maxlocalDepth && curr.size() > 1){
                        istheremax = true;
                        break;
                    }
                }
                if(istheremax == false){
                    for(int k = 0; k < this.modula; k++){
                        Vector curr = (Vector)this.hashTable.get(k);
                        if((int)curr.get(0) == maxlocalDepth){
                            curr.set(0, maxlocalDepth-1);
                        }
                    }
                    this.globalDepth--;
                    this.modula /= 2;
                    this.hashTable.setSize(this.modula);
                }
            }
        }
    }

    public String search(String studentID) {
        int id = Integer.parseInt(studentID.substring(1));
        int remain = id % this.modula;
        Vector bucket = (Vector)this.hashTable.get(remain);
        if(bucket.contains(studentID)){
            return Integer.toBinaryString(remain);
        }
        return "-1";
    }

    public void printLab() {
        System.out.println("Global depth : "+this.globalDepth);
        for(int i = 0; i < this.modula; i++){
            String temp = Integer.toBinaryString(i);
            for(int k = 0; k < (this.globalDepth-temp.length()); k++){
                System.out.print("0");
            }
            System.out.print(temp+" : ");
            Vector bucket = (Vector)this.hashTable.get(i);
            System.out.print("[Local depth:"+bucket.get(0)+"]");
            int size = bucket.size();
            for(int j = 1; j < size; j++){
                System.out.print("<"+bucket.get(j)+">");
            }
            System.out.print("\n");
        }
    }
    
}
