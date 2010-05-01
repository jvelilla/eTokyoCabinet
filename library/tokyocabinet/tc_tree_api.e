note
	description: "Summary description for {TC_TREE_API}. API of Ordered Tree TokyoCabinet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TC_TREE_API

feature -- Create

	tctreenew : POINTER
		--/* Create a tree object.
		--  The return value is the new tree object. */
		--TCTREE *tctreenew(void);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreenew()
			}"
		end


feature -- Delete


	tctreedel (a_tree : POINTER)
		--/* Delete a tree object.
		--   `tree' specifies the tree object.
		--   Note that the deleted object and its derivatives can not be used anymore. */
		--void tctreedel(TCTREE *tree);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreedel((TCTREE *)$a_tree)
			}"
		end


	tctreeclear (a_tree : POINTER)
		--/* Clear a tree object.
		--   `tree' specifies the tree object.
		--   All records are removed. */
		--void tctreeclear(TCTREE *tree);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeclear((TCTREE *)$a_tree)
			}"
		end
		
	tctreecutfringe(a_tree : POINTER; a_num : INTEGER_32)
		--/* Remove fringe records of a tree object.
		--   `tree' specifies the tree object.
		--   `num' specifies the number of records to be removed. */
		--void tctreecutfringe(TCTREE *tree, int num);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreecutfringe((TCTREE *)$a_tree, (int) $a_num)
			}"
		end

feature -- Element Change


--/* Add an integer to a record in a tree object.
--   `tree' specifies the tree object.
--   `kbuf' specifies the pointer to the region of the key.
--   `ksiz' specifies the size of the region of the key.
--   `num' specifies the additional value.
--   The return value is the summation value.
--   If the corresponding record exists, the value is treated as an integer and is added to.  If no
--   record corresponds, a new record of the additional value is stored. */
--int tctreeaddint(TCTREE *tree, const void *kbuf, int ksiz, int num);


--/* Add a real number to a record in a tree object.
--   `tree' specifies the tree object.
--   `kbuf' specifies the pointer to the region of the key.
--   `ksiz' specifies the size of the region of the key.
--   `num' specifies the additional value.
--   The return value is the summation value.
--   If the corresponding record exists, the value is treated as a real number and is added to.  If
--   no record corresponds, a new record of the additional value is stored. */
--double tctreeadddouble(TCTREE *tree, const void *kbuf, int ksiz, double num);


	tctreedup (a_tree : POINTER) : POINTER
		--/* Copy a tree object.
		--   `tree' specifies the tree object.
		--   The return value is the new tree object equivalent to the specified object. */
		--TCTREE *tctreedup(const TCTREE *tree);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreedup((const TCTREE *)$a_tree)
			}"
		end


	tctreeput (a_tree :POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_vbuf : POINTER; a_vsiz : INTEGER_32)
		--/* Store a record into a tree object.
		--   `tree' specifies the tree object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.
		--   If a record with the same key exists in the tree, it is overwritten. */
		--void tctreeput(TCTREE *tree, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeput((TCTREE *)$a_tree, (const void *)$a_kbuf, (int)$a_ksiz, (const void *)$a_vbuf, (int)$a_vsiz)
			}"
		end



	tctreeput2 (a_tree : POINTER; a_kstr : POINTER; a_vstr : POINTER)
		--/* Store a string record into a tree object.
		--   `tree' specifies the tree object.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If a record with the same key exists in the tree, it is overwritten. */
		--void tctreeput2(TCTREE *tree, const char *kstr, const char *vstr);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeput2((TCTREE *)$a_tree, (const char *)$a_kstr, (const char *)$a_vstr)
			}"
		end


	tctreeputkeep (a_tree : POINTER; a_kbuf : POINTER; a_ksiz: INTEGER_32; a_vbuf : POINTER; a_vsiz: INTEGER_32) : BOOLEAN
		--/* Store a new record into a tree object.
		--   `tree' specifies the tree object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the tree, this function has no effect. */
		--bool tctreeputkeep(TCTREE *tree, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeputkeep((TCTREE *)$a_tree, (const void *)$a_kbuf, (int) $a_ksiz, (const void *)$a_vbuf, (int) $a_vsiz)
			}"
		end


	tctreeputkeep2 ( a_tree : POINTER; a_kstr : POINTER; a_vstr : POINTER) : BOOLEAN
		--/* Store a new string record into a tree object.
		--   `tree' specifies the tree object.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the tree, this function has no effect. */
		--bool tctreeputkeep2(TCTREE *tree, const char *kstr, const char *vstr);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeputkeep2((TCTREE *)$a_tree, (const char *)$a_kstr, (const char *)$a_vstr)
			}"
		end



	tctreeputcat (a_tree : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_vbuf : POINTER; a_vsiz : INTEGER_32)
		--/* Concatenate a value at the end of the value of the existing record in a tree object.
		--   `tree' specifies the tree object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.
		--   If there is no corresponding record, a new record is created. */
		--void tctreeputcat(TCTREE *tree, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeputcat((TCTREE *)$a_tree, (const void *)$a_kbuf, (int) $a_ksiz, (const void *)$a_vbuf, (int) $a_vsiz)
			}"
		end



	tctreeputcat2 (a_tree : POINTER; a_kstr : POINTER; a_vstr : POINTER)
		--/* Concatenate a string value at the end of the value of the existing record in a tree object.
		--   `tree' specifies the tree object.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If there is no corresponding record, a new record is created. */
		--void tctreeputcat2(TCTREE *tree, const char *kstr, const char *vstr);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeputcat2((TCTREE *)$a_tree, (const char *)$a_kstr, (const char *)$a_vstr)
			}"
		end


	tctreeout (a_tree : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32) : BOOLEAN
		--/* Remove a record of a tree object.
		--   `tree' specifies the tree object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   If successful, the return value is true.  False is returned when no record corresponds to
		--   the specified key. */
		--bool tctreeout(TCTREE *tree, const void *kbuf, int ksiz);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeout((TCTREE *)$a_tree, (const void *)$a_kbuf, (int) $a_ksiz)
			}"
		end


	tctreeout2 (a_tree : POINTER; a_kstr : POINTER) : BOOLEAN
		--/* Remove a string record of a tree object.
		--   `tree' specifies the tree object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is true.  False is returned when no record corresponds to
		--   the specified key. */
		--bool tctreeout2(TCTREE *tree, const char *kstr);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeout2((TCTREE *)$a_tree, (const char *)$a_kstr)
			}"
		end

feature -- Access

	tctreeget (a_tree : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_sp : TYPED_POINTER[INTEGER_32]) : POINTER
		--/* Retrieve a record in a tree object.
		--   `tree' specifies the tree object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   If successful, the return value is the pointer to the region of the value of the
		--   corresponding record.  `NULL' is returned when no record corresponds.
		--   Because an additional zero code is appended at the end of the region of the return value,
		--   the return value can be treated as a character string. */
		--const void *tctreeget(TCTREE *tree, const void *kbuf, int ksiz, int *sp);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				int sp;
				void *result = tctreeget((TCTREE *)$a_tree, (const void *)$a_kbuf, (int) $a_ksiz, (int) &sp); 
				*(EIF_INTEGER *) $a_sp = (EIF_INTEGER) sp;
				return result;
			]"
		end


	tctreeget2 (a_tree : POINTER; a_kstr : POINTER) : POINTER
		--/* Retrieve a string record in a tree object.
		--   `tree' specifies the tree object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is the string of the value of the corresponding record.
		--   `NULL' is returned when no record corresponds. */
		--const char *tctreeget2(TCTREE *tree, const char *kstr);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeget2((TCTREE *)$a_tree, (const char *)$a_kstr)
			}"
		end



	tctreernum (a_tree : POINTER) : NATURAL_64
		--/* Get the number of records stored in a tree object.
		--   `tree' specifies the tree object.
		--   The return value is the number of the records stored in the tree object. */
		--uint64_t tctreernum(const TCTREE *tree);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreernum((const TCTREE *)$a_tree)
			}"
		end


	tctreemsiz (a_tree : POINTER) : NATURAL_64
		--/* Get the total size of memory used in a tree object.
		--   `tree' specifies the tree object.
		--   The return value is the total size of memory used in a tree object. */
		--uint64_t tctreemsiz(const TCTREE *tree);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreemsiz((const TCTREE *)$a_tree)
			}"
		end


	tctreekeys (a_tree : POINTER) : POINTER
		--/* Create a list object containing all keys in a tree object.
		--   `tree' specifies the tree object.
		--   The return value is the new list object containing all keys in the tree object.
		--   Because the object of the return value is created with the function `tclistnew', it should
		--   be deleted with the function `tclistdel' when it is no longer in use. */
		--TCLIST *tctreekeys(const TCTREE *tree);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreekeys((const TCTREE *)$a_tree)
			}"
		end


	tctreevals (a_tree : POINTER) : POINTER
		--/* Create a list object containing all values in a tree object.
		--   `tree' specifies the tree object.
		--   The return value is the new list object containing all values in the tree object.
		--   Because the object of the return value is created with the function `tclistnew', it should
		--   be deleted with the function `tclistdel' when it is no longer in use. */
		--TCLIST *tctreevals(const TCTREE *tree);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreevals((const TCTREE *)$a_tree)
			}"
		end
		
feature -- Iterator

	tctreeiterinit (a_tree : POINTER)
		--/* Initialize the iterator of a tree object.
		--   `tree' specifies the tree object.
		--   The iterator is used in order to access the key of every record stored in the tree object. */
		--void tctreeiterinit(TCTREE *tree);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeiterinit((TCTREE *)$a_tree)
			}"
		end


	tctreeiternext (a_tree : POINTER; a_sp : TYPED_POINTER[INTEGER_32]) : POINTER
		--/* Get the next key of the iterator of a tree object.
		--   `tree' specifies the tree object.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   If successful, the return value is the pointer to the region of the next key, else, it is
		--   `NULL'.  `NULL' is returned when no record can be fetched from the iterator.
		--   Because an additional zero code is appended at the end of the region of the return value,
		--   the return value can be treated as a character string.
		--   The order of iteration is assured to be ascending of the keys. */
		--const void *tctreeiternext(TCTREE *tree, int *sp);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				int sp;
				void *result = tctreeiternext((TCTREE *)$a_tree, (int)&sp);
				*(EIF_INTEGER *) $a_sp = (EIF_INTEGER) sp;
				return result;
			]"
		end
		
		
	tctreeiternext2 (a_tree : POINTER) : POINTER
		--/* Get the next key string of the iterator of a tree object.
		--   `tree' specifies the tree object.
		--   If successful, the return value is the pointer to the region of the next key, else, it is
		--   `NULL'.  `NULL' is returned when no record can be fetched from the iterator.
		--   The order of iteration is assured to be ascending of the keys. */
		--const char *tctreeiternext2(TCTREE *tree);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tctreeiternext2((TCTREE *)$a_tree)
			}"
		end
end
