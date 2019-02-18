// border pixel of windows
static const unsigned int borderpx = 0;

// snap pixel
static const unsigned int snap = 0;

// 0 means no bar
static const int showbar = 1;

// 0 means bottom bar
static const int topbar = 1;

// font
static const char *fonts[] = {"monospace:size=15"};
static const char dmenufont[] = "monospace:size=15";

// colors
static const char color_fg[] = "#839496";
static const char color_fg_selected[] = "#268bd2";
static const char color_bg[] = "#001E28";
static const char color_bg_selected[] = "#001E28";
static const char color_border[] = "#004A5C";
static const char color_border_selected[] = "#005D74";

// default terminal
static char terminal[] = "termite";

// fg, bg, border
static const char *colors[][3] = {
	[SchemeNorm] = {color_fg, color_bg, color_border},
	[SchemeSel] = {color_fg_selected, color_bg_selected, color_border_selected},
};

// tags
static const char *tags[] = {"tm", "fs", "cli", "vim", "www", "1", "2", "3"};

// Use xprop command to find out window details
// WM_CLASS(STRING) = class, instance
// WM_NAME(STRING) = title
// class, instance, title, tags mask, isfloating, monitor
static const Rule rules[] = {
	{"Transmission-gtk", NULL, NULL, 1 << 1, 0, -1},
	{"Chromium", NULL, NULL, 1 << 4, 0, -1},
	{"Gcolor3", NULL, NULL, 0, 1, -1},
};

// define default tag applications
static const char *todocmd[] = {terminal, "-e", "nvim /home/damage/TODO", NULL};
static const char *fmcmd[] = {terminal, "-e", "vifm", NULL};
static const char *clicmd[] = {terminal, NULL};
static const char *editorcmd[] = {terminal, "-e", "nvim", NULL};
static const char *browsercmd[] = {"chromium", NULL};

static TagApp tagapps[] = {
	{0, {.v = todocmd}},
	{1, {.v = fmcmd}},
	{2, {.v = clicmd}},
	{3, {.v = editorcmd}},
	{4, {.v = browsercmd}},
};

// factor of master area size [0.05..0.95]
static const float mfact = 0.5;

// number of clients in master area
static const int nmaster = 1;

// 1 means respect size hints in tiled resizals
static const int resizehints = 0;

// symbol arrange function
static const Layout layouts[] = {
	// first entry is default
	{"[T]", tile},
	{"[M]", monocle},
	// no layout function means floating behavior
	{"[F]", NULL},
};

// key definitions
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

// helper for spawning shell commands in the pre dwm-5.0 fashion
#define SHCMD(cmd) {.v = (const char*[]){"/bin/sh", "-c", cmd, NULL}}

// commands
static char dmenumon[2] = "0";
static const char *dmenucmd[] = {"dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", color_bg, "-nf", color_fg, "-sb", color_bg_selected, "-sf", color_fg_selected, NULL};
static const char *termcmd[] = {terminal, NULL};

static Key keys[] = {
	// modifier         key         function     argument
	{MODKEY,            XK_space,   spawn,       {.v = dmenucmd } },
	{MODKEY,            XK_Return,  spawn,       {.v = termcmd } },
	{MODKEY,            XK_b,       togglebar,   {0} },
	{MODKEY,            XK_j,       focusstack,  {.i = +1 } },
	{MODKEY,            XK_k,       focusstack,  {.i = -1 } },
	{MODKEY,            XK_i,       incnmaster,  {.i = +1 } },
	{MODKEY,            XK_d,       incnmaster,  {.i = -1 } },
	{MODKEY,            XK_h,       setmfact,    {.f = -0.05} },
	{MODKEY,            XK_l,       setmfact,    {.f = +0.05} },
	{MODKEY|ShiftMask,  XK_Return,  zoom,        {0} },
	{MODKEY,            XK_Tab,     view,        {0} },
	{MODKEY,            XK_q,       killclient,  {0} },
	{MODKEY,            XK_0,       view,        {.ui = ~0 } },
	{MODKEY|ShiftMask,  XK_0,       tag,         {.ui = ~0 } },
	{MODKEY,            XK_comma,   focusmon,    {.i = -1 } },
	{MODKEY,            XK_period,  focusmon,    {.i = +1 } },
	{MODKEY|ShiftMask,  XK_comma,   tagmon,      {.i = -1 } },
	{MODKEY|ShiftMask,  XK_period,  tagmon,      {.i = +1 } },
	TAGKEYS(            XK_t,                    0)
	TAGKEYS(            XK_f,                    1)
	TAGKEYS(            XK_c,                    2)
	TAGKEYS(            XK_v,                    3)
	TAGKEYS(            XK_w,                    4)
	TAGKEYS(            XK_1,                    5)
	TAGKEYS(            XK_2,                    6)
	TAGKEYS(            XK_3,                    7)
	{MODKEY|ShiftMask,  XK_q,       quit,        {0}},
};

// button definitions
// click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin
static Button buttons[] = {
	// click          event mask  button    function         argument
	{ ClkLtSymbol,    0,          Button1,  setlayout,       {0} },
	// { ClkLtSymbol,    0,          Button3,  setlayout,       {.v = &layouts[2]} },
	{ ClkWinTitle,    0,          Button2,  zoom,            {0} },
	{ ClkStatusText,  0,          Button2,  spawn,           {.v = termcmd } },
	{ ClkClientWin,   MODKEY,     Button1,  movemouse,       {0} },
	{ ClkClientWin,   MODKEY,     Button2,  togglefloating,  {0} },
	{ ClkClientWin,   MODKEY,     Button3,  resizemouse,     {0} },
	{ ClkTagBar,      0,          Button1,  view,            {0} },
	{ ClkTagBar,      0,          Button3,  toggleview,      {0} },
	{ ClkTagBar,      MODKEY,     Button1,  tag,             {0} },
	{ ClkTagBar,      MODKEY,     Button3,  toggletag,       {0} },
};
