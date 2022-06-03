#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
//#include <algorithm>
#include <time.h>

int main() {
    double trial[6]={}; //array containing input predictor variables
    std::cout << "\nThis is a model designed to predict your chance of surviving the 1912 Titanic\n\n";
    std::cout << "Enter PassengerClass:\n"<<"[1 = First Class, 2 = Second Class, 3 = Third Class]\n";
    std::cin >> trial[0];
    std::cout << "\nEnter Sex:\n"<<"[1 = Male, 2 = Female]\n";
    std::cin >> trial[1];
    std::cout << "\nEnter Age:\n";
    std::cin >> trial[2];
    std::cout << "\nEnter number of your siblings/spouses on board:\n";
    std::cin >> trial[3];
    std::cout << "\nEnter number of your parents/children on board:\n";
    std::cin >> trial[4];
    std::cout << "\nEnter fare you have paid, ranging from 1-500, note that majority falls in $10-$50 range:\n";
    std::cin >> trial[5];
    std::cout << "\nResults gathering...\n";
    int start = clock();

    double prediction = 0;
    int ntree = 350;
    
    for(int n = 1; n <= ntree; n++){ //main loop through forest
    std::string key = "#" + std::to_string(n);

    std::ifstream data("titanic_RF.csv");
    std::string line;
    std::vector<std::vector<std::string> > parsedCsv{};
    while(std::getline(data,line)) //parsing csv data to vector<string>, "parsedCsv"
    {
        if(line.find(key) != std::string::npos){
            std::stringstream lineStream(line);
            std::string cell;
            std::vector<std::string> parsedRow(7);
            int n = 0;
            while(std::getline(lineStream,cell,','))
            {
                //cell.erase(std::remove(cell.begin(), cell.end(), '"'), cell.end());
                parsedRow[n] = cell;
                if(n<7){n++;}
            }

            for(int p = 0; p < parsedRow.size(); p++) //removing double quotes from vector<string>
            {
                for ( unsigned int i = 0; i < parsedRow[p].length() ; ++i )
                {
                    if(parsedRow[p][i] == '"')
                    {
                        parsedRow[p].erase(i, 1);
                        i--;
                    }
                }
            }//end of removing double quote
            
            parsedCsv.push_back(parsedRow);
        }
    }

    double result = 0;
    for(int i = 0; result == 0; ) //gather result from individual tree
    {
        int left_split = stoi((parsedCsv[i])[1]) - 1;
        int right_split = stoi((parsedCsv[i])[2]) - 1;
        int predictor = stoi((parsedCsv[i])[3]) - 1; //array position of the node's split variable
        double split_point = std::stod((parsedCsv[i])[4]);

        if(predictor == -1){result = stoi((parsedCsv[i])[6]);} //when leaf node is reached
        else if(trial[predictor] <= split_point){i = left_split;} //left split
        else{i = right_split;} //right split
    }//End of individual tree
    
    prediction += result - 1; //extra "-1" as: 0/fail --> result=1; 1/survive --> result=2
    
    }//End of running through entire forest

    std::cout << "Your chance of survival is: " << prediction/ntree*100 << "%" << "\n";
    int end = clock();
    std::cout << "Execution has taken " << ((float)end - start)/CLOCKS_PER_SEC << " seconds.\n";
    std::cout << "Thank you for participating!" << "\n\n";

    system("pause");
    return 0;
}