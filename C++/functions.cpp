using namespace std;

void setallzero(string *mylist)
{
	for (int i = 0; i < imax; i++)
	{
		mylist[i] = "";
	}

}

void getnames(string *mylist)
{
	DIR*     dir; 
	dirent*  pdir;
	
	int i = 0;
	string var;
	
    dir = opendir(".");  // open current directory

    while (pdir = readdir(dir)) 
	{
        mylist[i] = pdir -> d_name;

		i++;
    }
	
    closedir(dir);
}

int getcount(string *mylist)
{
	int count = 0;
	
	for (int i = 0; i < imax; i++)
	{
		if (mylist[i] != "")
		{
			count++;
		}		
	}
	
	return count;
}


string* filter(string* mylist, string* newlist, string mypattern)
{
	string filename;
	
	int count = 0;

	for (int i = 0; i < file_count; i++) 
	{
		filename = mylist[i];		
		if (filename.find(mypattern) != string::npos) 
		{
			newlist[count] = filename;
			count++;
		} 
	}
	return newlist;
}

void makedir(string name)
{
	mkdir(name.c_str());
}

void copyfile(string source, string destination)
{
	CopyFile(source.c_str(), destination.c_str(), TRUE);
}

string inttostr(int Number)
{
	ostringstream converter; 
	converter << Number;
	return converter.str();
}

void renamefile(string oldfilename, string newfilename)
{
	rename(oldfilename.c_str(), newfilename.c_str());
}

void converttoavi(string oldfilename, string newfilename)
{
	std::stringstream ss;
	
	// cout << "Converting " << oldfilename << " to " << newfilename << endl;
	
	ss << "ffmpeg -i " << oldfilename << " -s 426x240 -y " << newfilename << " -loglevel 0";	
	
	system(ss.str().c_str());
}

void converttofmf(string myfilename)
{
	// cout << "Converting " << myfilename << " to FMF format..." << endl;
	
	std::stringstream ss;
	
	ss << "ffmpeg2fmf --format=mono8 " << myfilename;
	
	system(ss.str().c_str());
}

void deletefile(string myfile)
{
	const char *c = myfile.c_str();
	
	remove(c);
}

void progressbar(int mypercent)
{
  string bar;

  for(int i = 0; i < 50; i++)
  {
    if( i < (mypercent/2))
	{
      bar.replace(i,1,"=");
    }
	else if( i == (mypercent/2))
	{
      bar.replace(i,1,">");
    }
	else
	{
      bar.replace(i,1," ");
    }
  }

  cout << "\r" "[" << bar << "] ";
  cout.width( 3 );
  cout << mypercent << "%     " << flush;
}

int percentage(int mynum, int mytotal)
{
	float number = float(mynum);
	float total = float(mytotal);
		
	float mypercentage = (number/total) * 100;	
	
	int returnvar = int(mypercentage);
	
	return returnvar;
}