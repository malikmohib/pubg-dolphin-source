#ifndef INI_RW
#define INI_RW

typedef struct ini INI;

INI *ini_load(char *path);
char **ini_list_sections(INI *ini);
char **ini_list_items(INI *ini, char *section);
char *ini_read(INI *ini, char *section, char *item);
int ini_write(INI *ini, char *section, char *item, char *value);
int ini_remove(INI *ini, char *section, char *item);
void ini_free(INI *ini);

namespace configManager{

char *readString(INI* config,const char *section,const  char *key, char *deValue);

int readInteger(INI* config,const char *section,const  char *key, int deValue);

float readFloat(INI* config,const char *section,const  char *key, float deValue);

bool readBoolean(INI* config,const char *section,const  char *key, bool deValue);

void putString(INI* config,const char *section,const  char *key, char *value);

void putInteger(INI* config,const char *section,const  char *key, int value);

void putFloat(INI* config,const char *section,const  char *key, float value);

void putBoolean(INI* config,const char *section,const  char *key, bool value);
}

#endif
