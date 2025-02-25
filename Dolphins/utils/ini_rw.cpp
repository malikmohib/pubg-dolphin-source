#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ini_rw.h"

typedef struct section_t section_t;
typedef struct item_t item_t;

/* work around the mysteries of PATH_MAX without including anything */
#ifndef PATH_MAX
#define PATH_MAX 4096
#endif

#define FREE_SECTION(s) free(s->name); free(s)
#define FREE_ITEM(i) free(i->name); free(i->value); free(i)

struct section_t {
    char *name;
    item_t *items;
    item_t *tail;
    section_t *next;
};
struct item_t {
    char *name;
    char *value;
    item_t *next;
};
struct ini {
    char **section_names;
    char **item_names;
    section_t *sections;
    section_t *tail;
    char file[PATH_MAX];
};

static void save_file(INI *ini) {
    FILE *f = fopen(ini->file, "w");
    /* write ini data structure to file, FTB to maintain original order */
    for (section_t *s = ini->sections; s; s = s->next) {
        fprintf(f, "[%s]\n", s->name);
        for (item_t *i = s->items; i; i = i->next) {
            fprintf(f, "%s = %s\n", i->name, i->value);
        }
        if (s->next) {
            fputs("\n", f);
        }
    }
    fclose(f);
}

static void free_section_names(INI *ini) {
    /* nothing loaded */
    if (!ini->section_names) {
        return;
    }
    
    int i = -1;
    while (ini->section_names[++i]) {
        free(ini->section_names[i]);
    }
    free(ini->section_names);
    ini->section_names = NULL;
}

static void free_item_names(INI *ini) {
    /* nothing loaded */
    if (!ini->item_names) {
        return;
    }
    
    int i = -1;
    while (ini->item_names[++i]) {
        free(ini->item_names[i]);
    }
    free(ini->item_names);
    ini->item_names = NULL;
}

static section_t *find_section(INI *ini, char *name) {
    /* nothing loaded */
    if (!ini->sections) {
        return NULL;
    }
    
    section_t *r = NULL;
    for (section_t *s = ini->sections; s; s = s->next) {
        if (!strcmp(name, s->name)) {
            r = s;
            break;
        }
    }
    return r;
}

static item_t *find_item(section_t *s, char *name) {
    /* section empty */
    if (!s->items) {
        return NULL;
    }
    
    item_t *r = NULL;
    for (item_t *i = s->items; i; i = i->next) {
        if (!strcmp(name, i->name)) {
            r = i;
            break;
        }
    }
    return r;
}

static section_t *add_section(INI *ini, char *name) {
    /* return any existing section */
    section_t *s;
    if ((s = find_section(ini, name))) {
        return s;
    }
    
    /* alloc new section */
    s = (section_t *) malloc(sizeof(section_t));
    s->name = (char *) malloc(strlen(name) + 1);
    strcpy(s->name, name);
    s->next = NULL;
    s->items = NULL;
    
    /* add section BTF, at head when no sections existed yet */
    if (!ini->sections) {
        ini->sections = s;
    } else {
        ini->tail->next = s;
    }
    ini->tail = s;
    return ini->tail;
}

static int add_item(INI *ini, char *section, char *item, char *value) {
    int r = 0;
    section_t *s = add_section(ini, section);
    item_t *i = find_item(s, item);
    
    if (!i) { /* new item created */
        r++;
        i = (item_t*)malloc(sizeof(item_t));
        i->name = (char*)malloc(strlen(item) + 1);
        strcpy(i->name, item);
        i->value = (char*)malloc(strlen(value) + 1);
        strcpy(i->value, value);
        i->next = NULL;
    } else if (strcmp(value, i->value)) { /* existing item updated */
        i->value = (char*)realloc(i->value, strlen(value) + 1);
        strcpy(i->value, value);
        save_file(ini);
        return ++r;
    } else { /* item exists with same value */
        return r;
    }
    
    /* add item BTF, at head when no items existed yet */
    if (!s->items) {
        r++;
        s->items = i;
    } else {
        s->tail->next = i;
    }
    s->tail = i;
    
    return r;
}

static int rm_section(INI *ini, section_t *s) {
    int r = 0;
    /* clear items */
    while (s->items) {
        r++;
        item_t *i = s->items;
        s->items = i->next;
        FREE_ITEM(i);
    }
    
    /* section was head */
    if (s == ini->sections) {
        ini->sections = s->next;
        FREE_SECTION(s);
        return ++r;
    }
    
    /* section in middle or tail */
    section_t *s_ = ini->sections;
    for (; s_->next != s; s_ = s_->next) {
    }
    s_->next = s->next;
    FREE_SECTION(s);
    if (!s_->next) {
        ini->tail = s_;
    }
    return ++r;
}

INI *ini_load(char *path) {
    INI *ini = (INI*)malloc(sizeof(INI));
    strcpy(ini->file, path);
    ini->sections = NULL;
    ini->section_names = NULL;
    ini->item_names = NULL;
    
    /* obtain file and size */
    FILE *f = fopen(ini->file, "r");
    if (!f) { /* file doesnt exist yet nothing to load */
        return ini;
    }
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    
    /* read in file */
    fseek(f, 0, SEEK_SET);
    char data[size + 1];
    fread(data, 1, size, f);
    data[size] = '\0';
    
    char *r = data;
    char *line_end = NULL;
    char *current_section = NULL;
    char *section_begin = NULL;
    char *item_begin = NULL;
    while ((line_end = strchr(r, '\n'))) {
        if (r[0] == ';' || r[0] == '#') { /* skip comments */
            r = line_end + 1;
            continue;
        }
        if ((section_begin = strchr(r, '[')) && section_begin < line_end && section_begin < strchr(r, '=')) {
            /* extract section */
            int l = (int)(strchr(r, ']') - section_begin);
            char section[l];
            strncpy(section, section_begin + 1, l);
            strchr(section, ']')[0] = '\0';
            
            /* store */
            section_t *s = add_section(ini, section);
            current_section = s->name;
        } else if ((item_begin = strchr(r, '=')) && item_begin < line_end) {
            /* extract item */
            char item[item_begin - r];
            while (r[0] == ' ' || r[0] == '\t') {
                r++;
            }
            strncpy(item, r, item_begin - r);
            int pad_end = (int)(item_begin - r);
            while (item[pad_end - 1] == ' ' || item[pad_end - 1] == '\t') {
                pad_end--;
            }
            item[pad_end] = '\0';
            
            /* extract value */
            char value[line_end - item_begin];
            r = item_begin + 1;
            while (r[0] == ' ' || r[0] == '\t') {
                r++;
            }
            strncpy(value, r, line_end - r);
            value[line_end - r] = '\0';
            
            /* store */
            add_item(ini, current_section, item, value);
        }
        r = line_end + 1;
    }
    fclose(f);
    return ini;
}

char **ini_list_sections(INI *ini) {
    /* rebuild sections list on request, store in ini * */
    free_section_names(ini);
    
    /* check if theres anything to list loaded */
    if (!ini->sections) {
        return ini->section_names;
    }
    
    int n = 0;
    for (section_t *s = ini->sections; s; s = s->next, n++) {
        ini->section_names = (char**)realloc(ini->section_names, sizeof(char *) * (n + 2));
        ini->section_names[n] = (char*)malloc(strlen(s->name) + 1);
        strcpy(ini->section_names[n], s->name);
    }
    ini->section_names[n] = NULL;
    return ini->section_names;
}

char **ini_list_items(INI *ini, char *section) {
    /* make sure section exists */
    section_t *s;
    if (!(s = find_section(ini, section)) || !s->items) {
        return NULL;
    }
    
    /* rebuild item list on request, store in ini * */
    free_item_names(ini);
    int n = 0;
    for (item_t *i = s->items; i; i = i->next, n++) {
        ini->item_names = (char**)realloc(ini->item_names, sizeof(char *) * (n + 2));
        ini->item_names[n] = (char*)malloc(strlen(i->name) + 1);
        strcpy(ini->item_names[n], i->name);
    }
    ini->item_names[n] = NULL;
    return ini->item_names;
}


char *ini_read(INI *ini, char *section, char *item) {
    section_t *s;
    item_t *i;
    if (!(s = find_section(ini, section)) || !(i = find_item(s, item))) {
        return NULL;
    }
    
    return i->value;
}

int ini_write(INI *ini, char *section, char *item, char *value) {
    int r = add_item(ini, section, item, value);
    if (r) {
        save_file(ini);
    }
    return r;
}

int ini_remove(INI *ini, char *section, char *item) {
    section_t *s;
    item_t *i = nullptr;
    
    /* nothing found to remove */
    if (!(s = find_section(ini, section)) || (item && !(i = find_item(s, item)))) {
        return 0;
    }
    
    /* remove entire section when item is NULL
     * or this was the last item in section */
    if (!item || !s->items->next) {
        int r = rm_section(ini, s);
        save_file(ini);
        return r;
    }
    
    /* item was head */
    if (i == s->items) {
        s->items = i->next;
        FREE_ITEM(i);
        save_file(ini);
        return 1;
    }
    
    /* item in middle or tail */
    item_t *i_ = s->items;
    for (; i_->next != i; i_ = i_->next) {
    }
    i_->next = i->next;
    FREE_ITEM(i);
    if (!i_->next) {
        s->tail = i_;
    }
    save_file(ini);
    return 1;
}

void ini_free(INI *ini) {
    while (ini->sections) {
        rm_section(ini, ini->sections);
    }
    free_section_names(ini);
    free_item_names(ini);
    free(ini);
}


char *configManager::readString(INI* config,const char *section, const char *key, char *deValue) {
    char *result = ini_read(config, (char*)section, (char*)key);
    if (result == NULL) {
        return deValue;
    }
    return result;
}

int configManager::readInteger(INI* config,const char *section, const char *key, int deValue) {
    char *result = ini_read(config, (char*)section, (char*)key);
    if (result == NULL) {
        return deValue;
    }
    return atoi(result);
}

float configManager::readFloat(INI* config,const char *section, const char *key, float deValue) {
    char *result = ini_read(config, (char*)section, (char*)key);
    if (result == NULL) {
        return deValue;
    }
    return atof(result);
}

bool configManager::readBoolean(INI* config,const char *section, const char *key, bool deValue) {
    char *result = ini_read(config, (char*)section, (char*)key);
    if (result == NULL) {
        return deValue;
    }
    return atoi(result);
}

void configManager::putString(INI* config,const char *section, const char *key, char *value) {
    ini_write(config, (char*)section, (char*)key, value);
}

void configManager::putInteger(INI* config,const char *section, const char *key, int value) {
    char buffer[32];
    sprintf(buffer, "%d", value);
    ini_write(config, (char*)section, (char*)key, buffer);
}

void configManager::putFloat(INI* config,const char *section, const char *key, float value) {
    char buffer[32];
    sprintf(buffer, "%f", value);
    ini_write(config, (char*)section, (char*)key, buffer);
}

void configManager::putBoolean(INI* config,const char *section, const char *key, bool value) {
    char buffer[32];
    sprintf(buffer, "%d", value);
    ini_write(config, (char*)section, (char*)key, buffer);
}

