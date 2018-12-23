#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mysql.h>
#include <stdarg.h>
#include <errno.h>
#include <time.h>
#include <stdbool.h>

#define QUERY_SIZE 256
#define BUFFER_SIZE 10

#define EMAIL_LEN 120
#define PASSWORD_LEN 40
#define NICKNAME_LEN 45
#define USERNAME_LEN 15

#define CHARACTER_LEN 45

#define ACTIVE_CHARS 4

/* Funkcija error_fatal() ispisuje poruku o gresci i potom prekida program. */
static void error_fatal (char *format, ...);

bool check_sign_in(MYSQL *connection, MYSQL_RES *resault, char *query, char* pass, int* player_id);
void sign_up(MYSQL *connection, MYSQL_RES *resault, char *query, char email[EMAIL_LEN], char pass[PASSWORD_LEN]);
void logout(MYSQL *connection, MYSQL_RES *resault, char *query, int player_id);

void format_time(char *output);
void clrscr();

typedef struct{
	int id;
	char name[CHARACTER_LEN];
	int skill_id;
	int level;
}character;


int main(int argc, char **argv){

	if(argc < 2){
		error_fatal("Error: Password not provided\n");
	}


	MYSQL *connection;	/* Promenljiva za konekciju. */
	MYSQL_RES *resault;/* Promenljiva za rezultat. */
	MYSQL_ROW row;		/* Promenljiva za jedan red rezultata. */
	//MYSQL_FIELD *field;	/* Promenljiva za nazive kolona. */
	unsigned port = 3380;


	int i;		/* Iterator in loop*/
	char c;
	int player_id = -1;
	int chosen_oponent_id;
	
	char query[QUERY_SIZE];		/* Promenljiva za formuaciju upita. */
	
	char email[EMAIL_LEN],
		 pass[PASSWORD_LEN],
		 username[USERNAME_LEN],
		 cur_time[25];
	connection = mysql_init (NULL);

	if (mysql_real_connect(connection, "localhost", "niko", argv[1], "game", port, NULL, 0) == NULL)
		error_fatal ("Greska u konekciji. %s\n", mysql_error(connection));

	clrscr();
	/* Attempt to login */
	do{
		fprintf(stdout, "%s\n", "Press 1 to sign in\nPress 2 to sign up");
		scanf("%c", &c);
		clrscr();
		if(c == '1'){
			do{
				fprintf(stdout, "%s\n", "Enter username: ");
				fscanf(stdin, "%s",username);
				fprintf(stdout, "%s\n", "Enter password: ");
				fscanf(stdin, "%s",pass);
				sprintf (query, "SELECT id, password FROM player Where user_name like \'%s\'", username);
				if(check_sign_in(connection, resault, query, pass, &player_id)) break;
				clrscr();
				fprintf(stdout, "%s\n", "Wrong username or Password. Try again" );
			}while(true);
			break;
		}
		if(c == '2'){
			clrscr();
			sign_up(connection, resault, query, email, pass);
			getc(stdin);
			c = '1';
			clrscr();
		}
		else {
			clrscr();
			fprintf(stderr, "%s\n","Incorect command. Try again\n");
		}
	}while(true);
	// Login finished
	// Menu ( start a game, online freinds, add a friend)
	clrscr();
	getc(stdin);
	do{

		fprintf(stdout, "Welcome to the game!\nChose action below:\n");
		fprintf(stdout, "1 : Start the game\n");
		fprintf(stdout, "2 : List freinds\n");
		fprintf(stdout, "3 : Add a freind\n");
		fprintf(stdout, "e : To exit the game\n");
		scanf("%c", &c);

		if(c == '1'){
			break;
		}
		else if(c == '2'){
				clrscr();
				sprintf (query, "SELECT user_name \
								 FROM player p join player_friends pf \
								 Where p.id = pf.player_id1\
								 	   and pf.player_id = %d",player_id);
				if (mysql_query (connection, query) != 0)
					error_fatal ("Greska u upitu %s\n", mysql_error (connection));
				resault = mysql_use_result (connection);
				while ((row = mysql_fetch_row(resault)) != 0){
					fprintf(stdout, "%s\n", row[0]);
				}
				sprintf (query, "SELECT user_name \
								 FROM player p join player_friends pf \
								 Where p.id = pf.player_id1\
								 	   and pf.player_id1 = %d",player_id);
				if (mysql_query (connection, query) != 0)
					error_fatal ("Greska u upitu %s\n", mysql_error (connection));
				resault = mysql_use_result (connection);
				while ((row = mysql_fetch_row(resault)) != 0){
					fprintf(stdout, "%s\n", row[0]);
				}
				getc(stdin);
				fprintf(stdout, "\n");

		}
		else if(c == '3'){
			int friend_id = -1;
			do{
				fprintf(stdout, "Enter players username you wish to add as friend\n");
				scanf("%s",username);
				sprintf (query, "SELECT id FROM player WHERE user_name like \'%s\'", username);
				if (mysql_query (connection, query) != 0)
					error_fatal ("Greska u upitu %s\n", mysql_error (connection));
				resault = mysql_use_result (connection);
				while ((row = mysql_fetch_row(resault)) != 0){
					friend_id = atoi(row[0]);
				}
				if(friend_id != -1) break;
				fprintf(stdout, "Player not found. Try again?(y|n)\n");
				scanf("%c",&c);getc(stdin);
				if(c == 'n') break;
				clrscr();
			}while(true);
			if(friend_id != player_id){
				sprintf (query, "INSERT INTO player_friends VALUES (\"%d\",\"%d\")",player_id,friend_id);
				if (mysql_query (connection, query) != 0){
					fprintf(stdout, "Player already in friends list\n");
				}
				fprintf(stdout, "Player added to friend list!\n");
			}
			clrscr();
			getc(stdin);
		}
		else if(c == 'e'){
			// logout
			logout(connection,resault,query,player_id);
			clrscr();
			exit(EXIT_SUCCESS);
		}
		else {
			fprintf(stderr, "%s\n","Incorect command. Try again\n");
			clrscr();

		}
	}while(true);

	//start a game
	clrscr();
	i = 0;
	character playable_character[ACTIVE_CHARS];
	sprintf (query, "SELECT id, name FROM `character` ORDER BY RAND() LIMIT %d",ACTIVE_CHARS);
	if (mysql_query (connection, query) != 0)
		error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	resault = mysql_use_result (connection);
	while ((row = mysql_fetch_row(resault)) != 0){
		playable_character[i].id = atoi(row[0]);
		strcpy(playable_character[i++].name,row[1]);
	}
	fprintf(stdout, "%s\n", "Select your character");
	for(i = 0 ; i< ACTIVE_CHARS; i++){
		fprintf(stdout, "%d : ", i+1);
		fprintf(stdout, "%s\n", playable_character[i].name);
	}
	fscanf(stdin, "%d",&i);
	character active_character;
	active_character.id = playable_character[i-1].id;
	strcpy(active_character.name,playable_character[i-1].name);
	clrscr();

	fprintf(stdout, "%s %s\n", "You have selected",active_character.name);
	fprintf(stdout, "%s\n", "Select Skill for your character:\n");
	sprintf (query, "SELECT skill_id, name FROM character_has_skill join skill on skill_id = id WHERE character_id = %d ",active_character.id);
	if (mysql_query (connection, query) != 0)
		error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	resault = mysql_use_result (connection);
	while ((row = mysql_fetch_row(resault)) != 0){
		fprintf(stdout, "%s : ",row[0] );
		fprintf(stdout, "%s \n",row[1] );
	}
	fscanf(stdin, "%d",&i);
	active_character.skill_id = i;
	clrscr();

	fprintf(stdout, "%s\n", "Select level:");
	sprintf (query, "SELECT id FROM level");
	if (mysql_query (connection, query) != 0)
		error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	resault = mysql_use_result (connection);
	while ((row = mysql_fetch_row(resault)) != 0){
		fprintf(stdout, "%s\n",row[0] );
	}
	fscanf(stdin, "%d",&i);
	active_character.level = i;

	fprintf(stdout, "%s\n", "Generating map...");
	// Randomly checking if map id exits
	srand(time(NULL));
	int map_id = rand();
	sprintf (query, "SELECT * FROM map WHERE id = %d", map_id);
	if (mysql_query (connection, query) != 0)
		error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	resault = mysql_use_result (connection);
	bool map_exists = false;
	while ((row = mysql_fetch_row(resault)) != 0){
		map_exists = true;
	}
	if(!map_exists){
		int object_id;
		format_time(cur_time);
		sprintf (query, "INSERT INTO map VALUES (\"%d\",\"%s\")", map_id, cur_time);
		if (mysql_query (connection, query) != 0)
			error_fatal ("Greska u upitu %s\n", mysql_error (connection));
		sprintf (query, "SELECT id FROM object ORDER BY RAND() LIMIT 1");
		if (mysql_query (connection, query) != 0)
			error_fatal ("Greska u upitu %s\n", mysql_error (connection));
		resault = mysql_use_result (connection);
		while ((row = mysql_fetch_row(resault)) != 0)
			object_id = atoi(row[0]);
		sprintf (query, "INSERT INTO map_has_object VALUES (\"%d\",\"%d\",\"%s\")", map_id, object_id,"10.2 21.2");
		if (mysql_query (connection, query) != 0)
			error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	}

	sprintf (query, "SELECT id FROM oponent ORDER BY RAND() LIMIT 1");
	if (mysql_query (connection, query) != 0)
		error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	resault = mysql_use_result (connection);
	while ((row = mysql_fetch_row(resault)) != 0)
		chosen_oponent_id = atoi(row[0]);

	bool oppnent_exits = false;
	sprintf (query, "SELECT * FROM level_has_oponent WHERE oponent_id = %d and level_id = %d", chosen_oponent_id, active_character.level);
	if (mysql_query (connection, query) != 0)
		error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	resault = mysql_use_result (connection);
	while ((row = mysql_fetch_row(resault)) != 0){
		oppnent_exits = true;
	}
	if(!oppnent_exits){
		sprintf (query, "INSERT INTO level_has_oponent VALUES (\"%d\",\"%d\",\"%d\",\"%d\")", active_character.level, chosen_oponent_id,rand(),rand()%10 + 5);
		if (mysql_query (connection, query) != 0)
			error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	}

	clrscr();
	fprintf(stdout, "%s\n", "Map generated...");
	fprintf(stdout, "%s\n", "Player playing...");



	// check if player has previous score on this map
	int old_score = -1;
	sprintf (query, "SELECT score FROM highscore WHERE player_id = %d and map_id = %d", player_id, map_id);
	if (mysql_query (connection, query) != 0)
		error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	resault = mysql_use_result (connection);
	while ((row = mysql_fetch_row(resault)) != 0){
		old_score = atoi(row[0]);
	}
	int score = rand();
	if(old_score != -1 && score > old_score) {
		sprintf (query, "INSERT INTO highscore VALUES (\"%d\",\"%d\",\"%d\")", player_id, map_id, score);
		if (mysql_query (connection, query) != 0)
			error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	}
	clrscr();
	fprintf(stdout, "%s\n", "Thanks for playing!");

	
	

	// while ((row = mysql_fetch_row(resault)) != 0)
	// 	printf ("%s\n", row[0]);
	// printf ("\n");
	// mysql_free_result (resault);

	logout(connection,resault,query,player_id);
	mysql_free_result (resault);
	mysql_close (connection);
	return 1;
}

bool check_sign_in(MYSQL *connection, MYSQL_RES *resault, char *query, char* pass, int* player_id) {
	MYSQL_ROW row;

	char pass2[PASSWORD_LEN];
	char login_data[] = "Unsuccessful login";

	if (mysql_query (connection, query) != 0)
			error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	/* Preuzima se rezultat. */
	resault = mysql_use_result (connection);
	char cur_time[25];
	format_time(cur_time);
	while ((row = mysql_fetch_row (resault)) != 0){
		*player_id = atoi(row[0]);
		strcpy(pass2,row[1]);
	}
	bool match = (strcmp(pass,pass2) == 0)?(true):(false);
	if( *player_id != -1){
		/*						 TABLE 
		*	id, player_id, login_time, logout_time, login_data
		*/
		if(match) {
			strcpy(login_data,"Successful login");
		}
		sprintf (query, "INSERT INTO login_history (player_id,login_time,login_data) VALUES (\"%d\",\"%s\",\"%s\")", *player_id, cur_time, login_data);
		if (mysql_query (connection, query) != 0)
			error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	}
	return match;
}

void sign_up(MYSQL *connection, MYSQL_RES *resault, char *query, char email[EMAIL_LEN], char pass[PASSWORD_LEN]) {	
	do{
		fprintf(stdout, "%s\n", "Enter email: ");
		fscanf(stdin, "%s",email);
		do{
			fprintf(stdout, "%s\n", "Enter password: ");
			fscanf(stdin, "%s",pass);
			char pass2[PASSWORD_LEN];
			fprintf(stdout, "%s\n", "Re-enter password: ");
			fscanf(stdin, "%s",pass2);
			if( !strcmp(pass,pass2) ) break;
			fprintf(stdout, "%s\n", "Passwords do not match. Try again" );
		}while(true);
		char username[USERNAME_LEN],
			 nickname[NICKNAME_LEN];
		fprintf(stdout, "%s\n", "Pick username:" );
		fscanf(stdin, "%s",username);
		fprintf(stdout, "%s\n", "Pick nickname:" );
		fscanf(stdin, "%s",nickname);

		sprintf (query, "INSERT INTO player VALUES (null,\"%s\",\"%s\",\"%s\",\"%s\")", username, pass, nickname, email);
		if (!mysql_query (connection, query)) break;
		fprintf(stdout, "%s\n", "Email or username already exists. Try again\n" );
	}while(true);
}

void logout(MYSQL *connection, MYSQL_RES *resault, char *query, int player_id){
	int cur_log_id = -1;
	MYSQL_ROW row;
	sprintf (query, "SELECT MAX(id) FROM login_history");
	if (mysql_query (connection, query) != 0)
		error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	resault = mysql_use_result (connection);
	while ((row = mysql_fetch_row(resault)) != 0)
		cur_log_id = atoi(row[0]);
	char cur_time[25];
	format_time(cur_time);
	sprintf (query, "UPDATE login_history SET  logout_time = \"%s\" Where player_id = %d and id = %d", cur_time, player_id, cur_log_id);
	if (mysql_query (connection, query) != 0){
		error_fatal ("Greska u upitu %s\n", mysql_error (connection));
	}
}


static void error_fatal (char *format, ...) {
	va_list arguments;
	va_start (arguments, format);
	vfprintf (stderr, format, arguments);
	va_end (arguments);
	exit (EXIT_FAILURE);
}

void format_time(char *output){
	time_t rawtime;
	struct tm * timeinfo;

	time ( &rawtime );
	timeinfo = localtime ( &rawtime );

	sprintf(output, "%d-%d-%d %d:%d:%d", timeinfo->tm_year + 1900, timeinfo->tm_mon + 1, timeinfo->tm_mday, timeinfo->tm_hour, timeinfo->tm_min, timeinfo->tm_sec);
}
/*
gcc -I/usr/include/mysql app.cpp -L/usr/lib/mysql -lmysqlclient -o app

*/

void clrscr() {
    system("@cls||clear");
}