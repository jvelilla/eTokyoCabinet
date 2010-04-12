class TC_LIST_2

create
make

feature {NONE} -- Initialization

make
do
items := tclistnew
end

feature -- Access

item (i: INTEGER): POINTER
require
exists: items /= default_pointer
local
l_size: INTEGER
do
Result := tclistval (items, i, $l_size)
end

feature {NONE} -- C externals

tclistnew: POINTER
external
"C inline use <tcutil.h> "
alias
"return tclistnew(); "
end

tclistval (a_list: POINTER; a_index: INTEGER; a_size: TYPED_POINTER
[INTEGER]): POINTER
external
"C inline use <tcutil.h> "
alias
"[
int size;
void *result = tclistval((TCLIST *) $a_list, (int)
$a_index, &size);
*(EIF_INTEGER *) $a_size = (EIF_INTEGER) size;
return result;
]"
end
feature
items : POINTER
end
