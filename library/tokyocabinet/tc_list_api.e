note
	description: "{TC_LIST_API}.  array list of tokyo cabinet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TC_LIST_API

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

	tclistnew2 (a_num : INTEGER) : POINTER
		--	Create a list object with expecting the number of elements.
		--  `anum' specifies the number of elements expected to be stored in the list.
		--   The return value is the new list object. */
		--TCLIST *tclistnew2(int anum);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistnew2((int)$a_num)
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



	tclistclear ( a_list : POINTER )
		--/* Clear a list object.
		--   `list' specifies the list object.
		--   All elements are removed. */
		--void tclistclear(TCLIST *list);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistclear((TCLIST *)$a_list)
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


	tclistval (a_list: POINTER; a_index: INTEGER_32; a_size: TYPED_POINTER [INTEGER_32]): POINTER
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
			"[
				int size;
				void *result = tclistval((TCLIST *) $a_list, (int)
				$a_index, &size);
				*(EIF_INTEGER *) $a_size = (EIF_INTEGER) size;
				return result;
			]"
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


	tclistdup (a_list : POINTER) : POINTER
		--/* Copy a list object.
		--   `list' specifies the list object.
		--   The return value is the new list object equivalent to the specified object. */
		--TCLIST *tclistdup(const TCLIST *list);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistdup((TCLIST *)$a_list)
			}"
		end

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

	tclistpop (a_list : POINTER; a_sp: TYPED_POINTER[INTEGER_32]) : POINTER
		--/* Remove an element of the end of a list object.
		--   `list' specifies the list object.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   The return value is the pointer to the region of the removed element.
		--   Because an additional zero code is appended at the end of the region of the return value,
		--   the return value can be treated as a character string.  Because the region of the return
		--   value is allocated with the `malloc' call, it should be released with the `free' call when it
		--   is no longer in use.  If the list is empty, the return value is `NULL'. */
		--void *tclistpop(TCLIST *list, int *sp);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				int sp;
				void *result = tclistpop((TCLIST *) $a_list, (int) &sp);
				*(EIF_INTEGER *) $a_sp = (EIF_INTEGER) sp;
				return result;
			]"
		end

	tclistpop2 (a_list : POINTER) : POINTER
		--/* Remove a string element of the end of a list object.
		--   `list' specifies the list object.
		--   The return value is the string of the removed element.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use.  If the list is empty, the return
		--   value is `NULL'. */
		--char *tclistpop2(TCLIST *list)
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistpop2((TCLIST *)$a_list)
			}"
		end


	tclistunshift (a_list : POINTER;  a_ptr : POINTER;  a_size : INTEGER)
		--/* Add an element at the top of a list object.
		--   `list' specifies the list object.
		--   `ptr' specifies the pointer to the region of the new element.
		--   `size' specifies the size of the region. */
		--void tclistunshift(TCLIST *list, const void *ptr, int size);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistunshift((TCLIST *)$a_list, (const void *)$a_ptr, (int)$a_size)
			}"
		end


	tclistunshift2 (a_list : POINTER; a_str : POINTER)
		--/* Add a string element at the top of a list object.
		--   `list' specifies the list object.
		--   `str' specifies the string of the new element. */
		--void tclistunshift2(TCLIST *list, const char *str);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistunshift2((TCLIST *)$a_list, (const char *)$a_str)
			}"
		end


	tclistshift (a_list : POINTER;  a_sp : TYPED_POINTER[INTEGER_32]) : POINTER
		--/* Remove an element of the top of a list object.
		--   `list' specifies the list object.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   The return value is the pointer to the region of the removed element.
		--   Because an additional zero code is appended at the end of the region of the return value,
		--   the return value can be treated as a character string.  Because the region of the return
		--   value is allocated with the `malloc' call, it should be released with the `free' call when it
		--   is no longer in use.  If the list is empty, the return value is `NULL'. */
		--void *tclistshift(TCLIST *list, int *sp);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				int sp;
				void *result = tclistshift((TCLIST *) $a_list, (int) &sp);
				*(EIF_INTEGER *) $a_sp = (EIF_INTEGER) sp;
				return result;
			]"
		end


	tclistshift2 (a_list : POINTER) : POINTER
		--/* Remove a string element of the top of a list object.
		--   `list' specifies the list object.
		--   The return value is the string of the removed element.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use.  If the list is empty, the return
		--   value is `NULL'. */
		--char *tclistshift2(TCLIST *list);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistshift2((TCLIST *)$a_list)
			}"
		end


	tclistinsert (a_list : POINTER an_index : INTEGER_32; a_ptr : POINTER; a_size : INTEGER_32)
		--	/* Add an element at the specified location of a list object.
		--   `list' specifies the list object.
		--   `index' specifies the index of the new element.
		--   `ptr' specifies the pointer to the region of the new element.
		--   `size' specifies the size of the region.
		--   If `index' is equal to or more than the number of elements, this function has no effect. */
		--void tclistinsert(TCLIST *list, int index, const void *ptr, int size);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistinsert((TCLIST *)$a_list, (int)$an_index, (const void *)$a_ptr, (int)$a_size)
			}"
		end


	tclistinsert2 (a_list : POINTER; an_index : INTEGER_32; a_str : POINTER)
		--/* Add a string element at the specified location of a list object.
		--   `list' specifies the list object.
		--   `index' specifies the index of the new element.
		--   `str' specifies the string of the new element.
		--   If `index' is equal to or more than the number of elements, this function has no effect. */
		--void tclistinsert2(TCLIST *list, int index, const char *str);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistinsert2((TCLIST *)$a_list, (int)$an_index, (const char *)$a_str)
			}"
		end


	tclistremove (a_list : POINTER; an_index : INTEGER_32; a_sp:TYPED_POINTER[INTEGER_32]) : POINTER
		--/* Remove an element at the specified location of a list object.
		--   `list' specifies the list object.
		--   `index' specifies the index of the element to be removed.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   The return value is the pointer to the region of the removed element.
		--   Because an additional zero code is appended at the end of the region of the return value,
		--   the return value can be treated as a character string.  Because the region of the return
		--   value is allocated with the `malloc' call, it should be released with the `free' call when it
		--   is no longer in use.  If `index' is equal to or more than the number of elements, no element
		--   is removed and the return value is `NULL'. */
		--void *tclistremove(TCLIST *list, int index, int *sp);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				int sp;
				void *result =tclistremove((TCLIST *)$a_list, (int)$an_index, (int)&sp);
				*(EIF_INTEGER *) $a_sp = (EIF_INTEGER) sp;
				return result;
			]"
		end


	tclistremove2 (a_list : POINTER; an_index : INTEGER_32) : POINTER
		--/* Remove a string element at the specified location of a list object.
		--   `list' specifies the list object.
		--   `index' specifies the index of the element to be removed.
		--   The return value is the string of the removed element.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use.  If `index' is equal to or more
		--   than the number of elements, no element is removed and the return value is `NULL'. */
		--char *tclistremove2(TCLIST *list, int index);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistremove2((TCLIST *)$a_list, (int) $an_index)
			}"
		end



	tclistover (a_list : POINTER; an_index : INTEGER_32; a_ptr : POINTER; a_size : INTEGER_32)
		--/* Overwrite an element at the specified location of a list object.
		--   `list' specifies the list object.
		--   `index' specifies the index of the element to be overwritten.
		--   `ptr' specifies the pointer to the region of the new content.
		--   `size' specifies the size of the new content.
		--   If `index' is equal to or more than the number of elements, this function has no effect. */
		--void tclistover(TCLIST *list, int index, const void *ptr, int size);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistover((TCLIST *)$a_list, (int)$an_index, (const void *)$a_ptr, (int)$a_size)
			}"
		end


	tclistover2 (a_list : POINTER; an_index : INTEGER_32; a_str : POINTER)
		--/* Overwrite a string element at the specified location of a list object.
		--   `list' specifies the list object.
		--   `index' specifies the index of the element to be overwritten.
		--   `str' specifies the string of the new content.
		--   If `index' is equal to or more than the number of elements, this function has no effect. */
		--void tclistover2(TCLIST *list, int index, const char *str);		
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistover2((TCLIST *)$a_list, (int)$an_index, (const char *)$a_str)
			}"
		end

feature -- Sort

	tclistsort (a_list : POINTER)
		--/* Sort elements of a list object in lexical order.
		--   `list' specifies the list object. */
		--void tclistsort(TCLIST *list);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistsort((TCLIST *)$a_list)
			}"
		end

feature -- Query

	tclistlsearch (a_list : POINTER; a_ptr : POINTER; a_size : INTEGER_32) : INTEGER_32
		--/* Search a list object for an element using liner search.
		--   `list' specifies the list object.
		--   `ptr' specifies the pointer to the region of the key.
		--   `size' specifies the size of the region.
		--   The return value is the index of a corresponding element or -1 if there is no corresponding
		--   element.
		--   If two or more elements correspond, the former returns. */
		--int tclistlsearch(const TCLIST *list, const void *ptr, int size);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistlsearch ((const TCLIST *)$a_list, (const void *)$a_ptr, (int)$a_size)
			}"
		end

	tclistbsearch (a_list : POINTER; a_ptr : POINTER; a_size : INTEGER_32) : INTEGER_32
		--/* Search a list object for an element using binary search.
		--   `list' specifies the list object.  It should be sorted in lexical order.
		--   `ptr' specifies the pointer to the region of the key.
		--   `size' specifies the size of the region.
		--   The return value is the index of a corresponding element or -1 if there is no corresponding
		--   element.
		--   If two or more elements correspond, which returns is not defined. */
		--int tclistbsearch(const TCLIST *list, const void *ptr, int size)
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tclistbsearch ((const TCLIST *)$a_list, (const void *)$a_ptr, (int)$a_size)
			}"
		end

end
