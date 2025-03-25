/*
    Copyright (C) 2022 Anna Nagel

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#include "dna_sim.h"
#include "string_utilities.h"

gsl_rng * r;  /* global generator */

int main(int argc, char **argv) {

	if (argc < 2) {
		printf("usage: dna_sim [-b] [-h] [-f] [-i] <-l> <-o> [-s] <-t> [-u]\n\n");
	}
  printf("Command to run:\n");
  for(int i=0; i < argc; i++) {
	  printf("%s ", argv[i]);
  }
  printf("\n");


  /* Set up random number generator */
  const gsl_rng_type * T;
  gsl_rng_env_setup();
  T = gsl_rng_default;
  r = gsl_rng_alloc(T);

  int c; /* Used for switch statement for getopt */
  char* endPtr; /* Needed for strtoul function*/
  char* token; /* Used to tokenize input strings */

  unsigned int RGSeed = 0;   /* Seed for random number generator */
  int randomStart = 1;       /* Determines if the sequence at the root
                             is given or choosen from the stationary distribution*/
  int numBases = 1000;       /* Number of bases in the sequence */
  double mu = 1.0;     /* Per base mutation rate, this is correct when the tree is in expected substitutions */
  double statFreq[4] = {.25, .25, .25, .25}; /* Stationary frequencies, of A, C, G, T */
  double rateParams[6] = {1, 1, 1, 1, 1, 1}; /* Parameters in the instantaneous rate matrix */
  int outFileNameGiven = 0;

  /* Used to confirm the required input files were given */
  int treeFileEntered = 0;

  char* outfile  = malloc(sizeof(char)*100);          /* Prefix of output file */
  char* treeFile = malloc(sizeof(char)*100);          /* Name of tree file, output from msprime*/
  char* inputFasta = malloc(sizeof(char)*30);         /* Name of file containing the ancestral sequence, optional*/
  char *fastaSeq =  NULL;                             /* Starting dna seqeunce */

  regex_t regDecimal, regInt;
  int regCompiled, regMatch;
  /* Regex for decimal number */
  regCompiled = regcomp(&regDecimal, "^([0-9]*)((.)([0-9]+))$" , REG_EXTENDED);
  if (regCompiled == 1) {
    fprintf(stderr, "Regular expression did not compile.\n");
    exit(1);
  }
  /* Regex for integer number */
  regCompiled = regcomp(&regInt, "^([0-9]+)$" , REG_EXTENDED);
  if (regCompiled == 1) {
    fprintf(stderr, "Regular expression did not compile.\n");
    exit(1);
  }

  /* Process command line arguements */
  while((c = getopt(argc, argv, "b:f:i:s:u:t:o:h")) != -1){
    switch(c) {
      /* Number of bases */
      case 'b':
        token = strtok(optarg, " ");
        regMatch = regexec(&regInt, token, 0, NULL, 0);
        if (regMatch != 0) {
          fprintf(stderr, "Number of bases is in the incorrect format. The number must be an integer. \nExiting the program. \n");
          exit(1);
        }
        numBases = atoi(optarg);
        break;

      /* Stationary frequencies followed by rate matrix parameters */
      case 'f':
        token = strtok(optarg, ":");
        regMatch = regexec(&regDecimal, token, 0, NULL, 0);
        checkModelInput(regMatch);
        statFreq[0] = atof(token);

        for (int i = 1; i < 3; i++) {
          token = strtok(NULL, ":");
          regMatch = regexec(&regDecimal, token, 0, NULL, 0);
          checkModelInput(regMatch);
          statFreq[i] = atof(token);
        }

        token = strtok(NULL, "-");
        regMatch = regexec(&regDecimal, token, 0, NULL, 0);
        checkModelInput(regMatch);
        statFreq[3] = atof(token);

        for (int i = 0; i < 6; i++) {
          token = strtok(NULL, ":");
          regMatch = regexec(&regDecimal, token, 0, NULL, 0);
          checkModelInput(regMatch);
          rateParams[i] = atof(token);
        }
        break;

//      /* File for ancestral DNA sequence */
//      case 'i':
//        strncpy(inputFasta, optarg, 30);
//        fastaSeq = string_from_file(inputFasta);
//	
// 	 if (! fastaSeq) {
// 	         fprintf(stderr,"Exiting the program.\n");
// 	         exit(1);
// 	 }
//        randomStart = 0;
//        break;

      /* Tree file from msprime  */
      case 't':
        strncpy(treeFile, optarg, 100);
        treeFileEntered = 1;
        break;

      /* Starting seed */
      case 's':
        token = strtok(optarg, " ");
        regMatch = regexec(&regInt, token, 0, NULL, 0);
        if (regMatch != 0) {
          fprintf(stderr, "The seed is in the incorrect format. The number must be an integer. \nExiting the program. \n");
          exit(1);
        }
        RGSeed = strtoul(optarg, &endPtr,10);
        break;

      /* Substitution rate */
      case 'u':
        token = strtok(optarg, " ");
        regMatch = regexec(&regDecimal, token, 0, NULL, 0);
        if (regMatch != 0) {
          fprintf(stderr, "Substitution rate is not in the correct format. \nIt must be a decimal number with a digit after the decimal.\nExiting the program.\n");
          exit(1);
        }
        mu = atof(token);

        break;
      case 'o':
        outFileNameGiven = 1;
        strncpy(outfile, optarg, 100);
        break;

     case 'h':
      printHelp();
      exit(0);
      break;

    default:
    fprintf(stderr, " Use -h to see valid arguments. Exiting the program.\n");
    exit(1);
    }
  }

  regfree(&regDecimal);
  regfree(&regInt);
  if (!outFileNameGiven) {
    fprintf(stderr, "Did not provide the output file name.\n");
    printHelp();
    fprintf(stderr, "Exiting the program.\n");
    exit(1);
  }

  if (!treeFileEntered) {
    fprintf(stderr, "Did not provide the tree file name.\n");
    printHelp();
    fprintf(stderr, "Exiting the program.\n");
    exit(1);
  }

  checkInput(statFreq, rateParams, mu); /* Checks input parameters are valid */
  setSeed(RGSeed, r, outfile);
  int* startSeq = setStartSeq (&numBases, randomStart, statFreq, fastaSeq, r);

  /* Read in newick format file. File needs to have internal node labels and
  branch lengths */
  char *treeString = string_from_file(treeFile);
  if (! treeString) {
	  fprintf(stderr,"Exiting the program.\n");
	  exit(1);
  }

  /* Make a tree from the input tree file */
  struct node* root_ptr = newNode(0);
  int endChar = makeTree(root_ptr, treeString, 0);

  if (treeString[endChar - 1] != '\0'  && treeString[endChar] != '\0' &&treeString[endChar + 1] != '\0' ) {
	  printf("%s\n", treeString + endChar);
	  printf("%s\n", treeString + endChar + 1);
	  printf("%d\n",  endChar );
    fprintf(stderr, "Problem reading in tree. Did not reach the end of the file \n");
    exit(1);
  }

  int numTips = countTips(root_ptr, 0); /* Number of tips in the tree */

  /* Needed for naming the sequences in the alignment. */
  struct node** nodeOrder = malloc(sizeof(struct node*) * numTips);

  char *treeStringCheck = strdup("");
  treeStringCheck = NewickStringBranchLength(root_ptr, treeStringCheck, 0);
  setTimes(root_ptr);

  assert(numTips * 2 - 1 == assign_CLV(root_ptr, 0));
  assert(numTips == findNodeOrder(root_ptr, nodeOrder, 0));

  /* Set the values of the instantaneous rate matrix. Sets diagonal and rescales to makes the mutation rate in the function. */
  double instRate[4][4] = { {                          0, rateParams[0] * statFreq[1],    rateParams[1] * statFreq[2],  rateParams[2] * statFreq[3]},
                {rateParams[0] * statFreq[0],                           0,    rateParams[3] * statFreq[2],  rateParams[4] * statFreq[3]},
                {rateParams[1] * statFreq[0], rateParams[3] * statFreq[1],                              0,  rateParams[5] * statFreq[3]},
                {rateParams[2] * statFreq[0], rateParams[4] * statFreq[1],    rateParams[5] * statFreq[2],                           0}};
  makeInstantaneousRate(instRate, statFreq, mu);

  /* Allocates the memory required for the alignment */
  char** alignment = allocateAlignmentMem(numTips, numBases);

  /* Generates and prints an alignment */
  makeAlignment(root_ptr, startSeq, instRate, alignment, nodeOrder, numBases, numTips, r, mu);
  printAlignment(alignment, numTips, nodeOrder, outfile);
  //printTreeNewNames(root_ptr, outfile);

  clearMemory(root_ptr, numTips, nodeOrder, alignment, treeString, r);
  free(treeFile);
  free(inputFasta);
  free(outfile);
  free(startSeq);
  return(0);
}
