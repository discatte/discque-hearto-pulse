// Created by Nokia64, Feb 18, 2021

#include <stdio.h>
#include <strings.h>

//~ For my friend Discatte =^.^=

int read_word(FILE* file, char str[], int array_len) {
	unsigned int i,n;
	for (i=0;i<array_len-2;i++){
		n = fgetc(file);
		if ((n>=33)&(n<=126)) { //Printable non-whitespace ASCII
			str[i] = n;
		} else {
			str[i] = 0;
			break;
		}
	}
	str[array_len-1]=0;
	return 0;
}

void skip_whitespace(FILE* file) {
	unsigned int i=0;
	while ((i <= 33) | (i>= 127)) {
		i = fgetc(file);
	}
	ungetc(i,file);
	return;
}


int main(int argc, char *argv[]) {
	unsigned int i,j,k;
	unsigned int w,h;
	FILE* in;
	FILE* out;
	char str[16];
	
	if (argc != 3) {
		fprintf(stderr,"Usage: %s [input.pgm] [output.nya]\n", argv[0]);
		return 1;
	}
	
	//Open input file
	in = fopen(argv[1],"rb");
	if (!in) {
		fprintf(stderr,"Error opening input file %s\n",argv[1]);
		return 1;
	}
	
	//Read file header (Should be "P5")
	skip_whitespace(in);
	read_word(in,str,16);
	i = strcmp(str,"P5");
	if (i!=0) {
		fprintf(stderr,"Error: unknown header %s found\n",str);
		return 1;
	}
	//Read image width
	skip_whitespace(in);
	read_word(in,str,16);
	w = atoi(str);
	//Read image height
	skip_whitespace(in);
	read_word(in,str,16);
	h = atoi(str);
	//Read image depth
	skip_whitespace(in);
	read_word(in,str,16);
	i = atoi(str);
	if (i>255) {
		fprintf(stderr,"Error: Depth of %d found. >255 unsupported\n",i);
		return 1;
	}
	
	//Show info
	fprintf(stderr,"%s: Width=%d Height=%d Depth=%d\n",argv[1],w,h,i);
	
	//Open output file
	out = fopen(argv[2],"wb");
	if (!in) {
		fprintf(stderr,"Error opening output file %s\n",argv[2]);
		return 1;
	}
	//Print header
	fprintf(out,"#declare %s =\n array[%d][%d]\n {\n",argv[1],w,h);
	//Print image data
	for (i=0;i<w;i++) {
		fputs("   {",out);
		for (j=0;j<h;j++) {
			k = fgetc(in);
			if (k==EOF) {fprintf(stderr,"Error: Unexpected EOF\n");return 1;}
			fprintf(out,"%03d",k);
			if (j==h-1) {
				fputs("},\n",out);
			} else {
				fputs(",",out);
			}
		}
		
	}
	//Final touch
	fputs(" }",out);
	
	//Close files
	fclose(in);
	fclose(out);
	
	return 0;
}
