using namespace std;

void display(int percentage)
{
	system("cls");
	cout << "\t \t \t ***AVI TO FMF CONVERSION***" << endl;
	cout << endl;
	cout << "Total number of files detected: " << filecount << endl;

	cout << "Conversion has started, please wait..."<< endl;

	cout << endl;
	progressbar(percentage);		
}