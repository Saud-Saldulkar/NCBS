import os, glob, threading, time;


def doTracking(name):
    print("ctrax --interactive=false --AutoDetectCircularArena=False --input="+name);
    os.system("ctrax --interactive=false --AutoDetectCircularArena=False --input="+name+"> moregarbage");
    os.system("ctrax --justsave=true --input="+name+"> moregarbage");


files = glob.glob("*.dv");

for i in files:
    i = i.replace(" ", "\ ");
    i = i.replace(";", "\;");
    newname = i.split(".")[0]+".avi"
    fmfname = i.split(".")[0]+".fmf"
    
    newname = newname.replace("\ ", "_");
    fmfname = fmfname.replace("\ ", "_");
    print("converting "+i+" to avi");
    os.system("ffmpeg -i "+i+" -s 426x240 -y "+ newname +" 2> garbagetoignore");
    os.system("ffmpeg -i "+newname+" 2> tempfile");
    f = open("tempfile")
    secs = 0;
    while 1:
        line = f.readline()
        if not line:
            break
        if line.find("Duration: ")==-1:
            continue
        t = line.split("Duration: ")[1].split(",")[0].split(":");
        secs = (float(t[0])*360+float(t[1])*60+float(t[2]));
    print(secs);
    #if secs < 480:
        #print(i + ' too short, skipping');
        #continue
    print("converting "+newname+" to fmf");
    os.system("ffmpeg2fmf --format=mono8 "+newname);
    print("tracking "+fmfname);
    threading.Thread(target = doTracking, kwargs = {"name":fmfname}).start();

while threading.activeCount() > 1:
    print('tracking in progress. waiting on '+str(threading.activeCount()-1)+' tracks');
    time.sleep(120);

print('done');