note
	description: "{TC_LIST}.  array list of tokyo cabinet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_LIST

feature -- Create List

	tclistnew : POINTER
		--/* Create a list object.
		--   The return value is the new list object. */
		--TCLIST *tclistnew(void)
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistnew()
			}"
		end

feature -- Delete

	tclistdel (a_list : POINTER)
		--/* Delete a list object.
		--   `list' specifies the list object.
		--   Note that the deleted object and its derivatives can not be used anymore. */
		--void tclistdel(TCLIST *list);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistdel((TCLIST *)$a_list)
			}"
		end

feature -- Query

	tclistnum (a_list : POINTER) : INTEGER
		--/* Get the number of elements of a list object.
		--   `list' specifies the list object.
		--   The return value is the number of elements of the list. */
		--int tclistnum(const TCLIST *list);	
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistnum((TCLIST *)$a_list)
			}"
		end


	tclistval (a_list : POINTER; an_index : INTEGER; a_sp : POINTER ) : POINTER
		--	/* Get the pointer to the region of an element of a list object.
		--   `list' specifies the list object.
		--   `index' specifies the index of the element.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   The return value is the pointer to the region of the value.
		--   Because an additional zero code is appended at the end of the region of the return value,
		--   the return value can be treated as a character string.  If `index' is equal to or more than
		--   the number of elements, the return value is `NULL'. */
		--const void *tclistval(const TCLIST *list, int index, int *sp);	
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistval((const TCLIST *)$a_list, (int)$an_index, (int *)$a_sp)
			}"
		end



	tclistval2 (a_list : POINTER; an_index : INTEGER) : POINTER
		--	/* Get the string of an element of a list object.
		--   `list' specifies the list object.
		--   `index' specifies the index of the element.
		--   The return value is the string of the value
		--   If `index' is equal to or more than the number of elements, the return value is `NULL'. */
		--const char *tclistval2(const TCLIST *list, int index);	
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistval2((const TCLIST *)$a_list, (int)$an_index)
			}"
		end

feature -- Element Change

	tclistpush (a_list : POINTER; a_ptr : POINTER; a_size : INTEGER)
		--/* Add an element at the end of a list object.
		--   `list' specifies the list object.
		--   `ptr' specifies the pointer to the region of the new element.
		--   `size' specifies the size of the region. */
		--void tclistpush(TCLIST *list, const void *ptr, int size)
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistpush((TCLIST *)$a_list, (const void *)$a_ptr, (int)$a_size)
			}"
		end



	tclistpush2 (a_list : POINTER; a_str : POINTER)
		--/* Add a string element at the end of a list object.
		--   `list' specifies the list object.
		--   `str' specifies the string of the new element. */
		--void tclistpush2(TCLIST *list, const char *str);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistpush2((TCLIST *)$a_list, (const char *)$a_str)
			}"
		end

end
