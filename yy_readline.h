//========================================================================
/** @type     C/C++ Header File
 *  @file     yy_readline.h
 *  @author   acornejo
 *  @date
 *   Created:       00:29:38 09/11/2005
 *   Last Update:   00:29:52 09/11/2005
 */
//========================================================================

static char *rl_line='\0';
static char *rl_start='\0';
static int   rl_len=0;

static int rl_input (char *buf, const int max)
{
    int result=0;

    if (rl_len == 0)
    {
        if (rl_start)
            free(rl_start);
        rl_start =(char *)readline("");
        if (rl_start == NULL)
            return 0;
        rl_line = rl_start;
        rl_len = strlen (rl_line)+1;
        if (rl_len != 1)
            add_history (rl_line);
        rl_line[rl_len-1] = '\n';
    }

    if (rl_len <= max)
    {
        strncpy (buf, rl_line, rl_len);
        result = rl_len;
        rl_len = 0;

        return result;
    }
    else
    {
        strncpy (buf, rl_line, max);
        result = max;
        rl_line += max;
        rl_len -= max;

        return max;
    }
}
#undef YY_INPUT
#define YY_INPUT(buf,res,max) (res=rl_input(buf,max))

