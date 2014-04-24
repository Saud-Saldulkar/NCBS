#include "head.h"

using namespace std;

const int imax = 150;
int file_count;
int filecount;




int main()
{	
	string* filelist = new string[imax];
	string* flist = new string[imax];
	
	setallzero(filelist);	
	setallzero(flist);
	
	getnames(filelist);
	file_count = getcount(filelist);
	
	string pattern = "avi";		
	
	filter(filelist, flist, pattern);
	
	filecount = getcount(flist);
	

	for (int i = 0; i < filecount; i++)
	{	
		int percent = percentage(i, filecount);
		
		display(percent);
		
		string foldername = "data" + inttostr(i);
		makedir(foldername);
		
		string source = flist[i];
		string destination = foldername + "/" + flist[i];
		copyfile(source, destination);

		string oldpath = foldername + "/" + flist[i];
		string newpath = foldername + "/" + "data" + inttostr(i) + ".avi";
		renamefile(oldpath,newpath);
		
		string avipath = foldername + "/" + "ndata" + inttostr(i) + ".avi";
		converttoavi(newpath,avipath);

		converttofmf(avipath);
		
		deletefile(newpath);
		deletefile(avipath);

	}
	
	display(100);
	
	return 0;
}

