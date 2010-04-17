note
	description: "Summary description for {TC_MAP}. API of Hash Map of TokyoCabinet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TC_MAP

feature -- Create Map


	tcmapnew : POINTER
		--/* Create a map object.
		--   The return value is the new map object. */
		--TCMAP *tcmapnew(void)
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapnew()
				}"
		end

feature -- Copy
	tcmapdup ( a_map : POINTER ) : POINTER
		--/* Copy a map object.
		--   `map' specifies the map object.
		--   The return value is the new map object equivalent to the specified object. */
		--TCMAP *tcmapdup(const TCMAP *map);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapdup((const TCMAP *)$a_map)
				}"
		end

feature -- Delete

	tcmapdel (a_map : POINTER)
		--/* Delete a map object.
		--   `map' specifies the map object.
		--   Note that the deleted object and its derivatives can not be used anymore. */
		--void tcmapdel(TCMAP *map)
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapdel((TCMAP *)$a_map)
				}"
		end


	tcmapclear (a_map : POINTER)
		--/* Clear a map object.
		--   `map' specifies the map object.
		--   All records are removed. */
		--void tcmapclear(TCMAP *map);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapclear((TCMAP *)$a_map)
				}"
		end


	tcmapcutfront (a_map: POINTER; a_num : INTEGER_32)
		--/* Remove front records of a map object.
		--   `map' specifies the map object.
		--   `num' specifies the number of records to be removed. */
		--void tcmapcutfront(TCMAP *map, int num);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapcutfront((TCMAP *)$a_map, (int)$a_num)
				}"
		end

feature -- Element Change

	tcmapput (a_map : POINTER; a_kbuf :POINTER; a_ksiz : INTEGER_32; a_vbuf : POINTER; a_vsiz : INTEGER_32)
		--/* Store a record into a map object.
		--   `map' specifies the map object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.
		--   If a record with the same key exists in the map, it is overwritten. */
		--void tcmapput(TCMAP *map, const void *kbuf, int ksiz, const void *vbuf, int vsiz)
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapput((TCMAP *)$a_map, (const void *)$a_kbuf, (int)$a_ksiz, (const void *)$a_vbuf, (int)$a_vsiz)
				}"
		end


	tcmapput2 (a_map : POINTER; a_kstr : POINTER;  a_vstr : POINTER)
		--/* Store a string record into a map object.
		--   `map' specifies the map object.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If a record with the same key exists in the map, it is overwritten. */
		--void tcmapput2(TCMAP *map, const char *kstr, const char *vstr);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapput2((TCMAP *)$a_map, (const char *)$a_kstr, (const char *)$a_vstr)
				}"
		end



	tcmapputkeep ( a_map : POINTER; a_kbuf :POINTER; a_ksiz: INTEGER_32; a_vbuf : POINTER; a_vsiz : INTEGER_32) : BOOLEAN
		--/* Store a new record into a map object.
		--   `map' specifies the map object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the map, this function has no effect. */
		--bool tcmapputkeep(TCMAP *map, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapputkeep((TCMAP *)$a_map, (const void *)$a_kbuf, (int)$a_ksiz, (const void *)$a_vbuf, (int)$a_vsiz)
				}"
		end


	tcmapputkeep2 (a_map : POINTER; a_kstr : POINTER; a_vstr : POINTER) : BOOLEAN
		--/* Store a new string record into a map object.
		--   `ma_p' specifies the map object.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the map, this function has no effect. */
		--bool tcmapputkeep2(TCMAP *map, const char *kstr, const char *vstr);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapputkeep2((TCMAP *)$a_map, (const char *)$a_kstr, (const char *)$a_vstr)
				}"
		end

	tcmapputcat (a_map : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_vbuf: POINTER; a_vsiz: INTEGER_32)
		--/* Concatenate a value at the end of the value of the existing record in a map object.
		--   `map' specifies the map object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.
		--   If there is no corresponding record, a new record is created. */
		--void tcmapputcat(TCMAP *map, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapputcat((TCMAP *)$a_map, (const void *)$a_kbuf, (int)$a_ksiz, (const void *)$a_vbuf, (int)$a_vsiz)
				}"
		end

	tcmapputcat2 ( a_map : POINTER; a_kstr :POINTER; a_vstr : POINTER)
		--/* Concatenate a string value at the end of the value of the existing record in a map object.
		--   `map' specifies the map object.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If there is no corresponding record, a new record is created. */
		--void tcmapputcat2(TCMAP *map, const char *kstr, const char *vstr);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapputcat2((TCMAP *)$a_map, (const char *)$a_kstr, (const char *)$a_vstr)
				}"
		end
		
		
	tcmapout (a_map : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER) : BOOLEAN
		--/* Remove a record of a map object.
		--   `map' specifies the map object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   If successful, the return value is true.  False is returned when no record corresponds to
		--   the specified key. */
		--bool tcmapout(TCMAP *map, const void *kbuf, int ksiz);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapout((TCMAP *)$a_map, (const void *)$a_kbuf, (int)$a_ksiz)
				}"
		end

	tcmapout2 (a_map : POINTER; a_kstr : POINTER) : BOOLEAN
		--/* Remove a string record of a map object.
		--   `map' specifies the map object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is true.  False is returned when no record corresponds to
		--   the specified key. */
		--bool tcmapout2(TCMAP *map, const char *kstr);
		external
			"C inline use <tcutil.h>"
		alias
			"{
				tcmapout2((TCMAP *)$a_map, (const char *)$a_kstr)
				}"
		end
		--/* Move a record to the edge of a map object.
		--   `map' specifies the map object.
		--   `kbuf' specifies the pointer to the region of a key.
		--   `ksiz' specifies the size of the region of the key.
		--   `head' specifies the destination which is the head if it is true or the tail if else.
		--   If successful, the return value is true.  False is returned when no record corresponds to
		--   the specified key. */
		--bool tcmapmove(TCMAP *map, const void *kbuf, int ksiz, bool head);


		--/* Move a string record to the edge of a map object.
		--   `map' specifies the map object.
		--   `kstr' specifies the string of a key.
		--   `head' specifies the destination which is the head if it is true or the tail if else.
		--   If successful, the return value is true.  False is returned when no record corresponds to
		--   the specified key. */
		--bool tcmapmove2(TCMAP *map, const char *kstr, bool head);


feature -- Query

	tcmapget (a_map: POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_sp:TYPED_POINTER[INTEGER_32]) : POINTER
		--/* Retrieve a record in a map object.
		--   `map' specifies the map object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   If successful, the return value is the pointer to the region of the value of the
		--   corresponding record.  `NULL' is returned when no record corresponds.
		--   Because an additional zero code is appended at the end of the region of the return value,
		--   the return value can be treated as a character string. */
		--const void *tcmapget(const TCMAP *map, const void *kbuf, int ksiz, int *sp);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				int sp;
				void *result = tcmapget((const TCMAP *)$a_map, (const void *)$a_kbuf, (int)$a_ksiz, &sp);
				*(EIF_INTEGER *) $a_sp = (EIF_INTEGER) sp;
				return result;
			]"
		end

	tcmapget2 (a_map : POINTER; a_kstr : POINTER) : POINTER
		--/* Retrieve a string record in a map object.
		--   `map' specifies the map object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is the string of the value of the corresponding record.
		--   `NULL' is returned when no record corresponds. */
		--const char *tcmapget2(const TCMAP *map, const char *kstr);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				tcmapget2((const TCMAP *)$a_map, (const char *)$a_kstr)
			]"
		end


	tcmaprnum (a_map : POINTER) : NATURAL_64
		--/* Get the number of records stored in a map object.
		--   `map' specifies the map object.
		--   The return value is the number of the records stored in the map object. */
		--uint64_t tcmaprnum(const TCMAP *map);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				tcmaprnum((const TCMAP *)$a_map)
			]"
		end

	tcmapmsiz (a_map : POINTER) : NATURAL_64
		--/* Get the total size of memory used in a map object.
		--   `map' specifies the map object.
		--   The return value is the total size of memory used in a map object. */
		--uint64_t tcmapmsiz(const TCMAP *map);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				tcmapmsiz((const TCMAP *)$a_map)
			]"
		end
		
		

	tcmapkeys (a_map : POINTER) : POINTER
		--/* Create a list object containing all keys in a map object.
		--   `map' specifies the map object.
		--   The return value is the new list object containing all keys in the map object.
		--   Because the object of the return value is created with the function `tclistnew', it should
		--   be deleted with the function `tclistdel' when it is no longer in use. */
		--TCLIST *tcmapkeys(const TCMAP *map);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				tcmapkeys((const TCMAP *)$a_map)
			]"
		end

	tcmapvals (a_map : POINTER) : POINTER
		--/* Create a list object containing all values in a map object.
		--   `map' specifies the map object.
		--   The return value is the new list object containing all values in the map object.
		--   Because the object of the return value is created with the function `tclistnew', it should
		--   be deleted with the function `tclistdel' when it is no longer in use. */
		--TCLIST *tcmapvals(const TCMAP *map);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				tcmapvals((const TCMAP *)$a_map)
			]"
		end



		--/* Add an integer to a record in a map object.
		--   `map' specifies the map object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `num' specifies the additional value.
		--   The return value is the summation value.
		--   If the corresponding record exists, the value is treated as an integer and is added to.  If no
		--   record corresponds, a new record of the additional value is stored. */
		--int tcmapaddint(TCMAP *map, const void *kbuf, int ksiz, int num);


		--/* Add a real number to a record in a map object.
		--   `map' specifies the map object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `num' specifies the additional value.
		--   The return value is the summation value.
		--   If the corresponding record exists, the value is treated as a real number and is added to.  If
		--   no record corresponds, a new record of the additional value is stored. */
		--double tcmapadddouble(TCMAP *map, const void *kbuf, int ksiz, double num);



feature -- Iterator

	tcmapiterinit (a_map : POINTER)
		--/* Initialize the iterator of a map object.
		--   `map' specifies the map object.
		--   The iterator is used in order to access the key of every record stored in the map object. */
		--void tcmapiterinit(TCMAP *map);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				tcmapiterinit((TCMAP *)$a_map)
			]"
		end

	tcmapiternext (a_map : POINTER;  a_sp: TYPED_POINTER[INTEGER_32]) : POINTER
		--/* Get the next key of the iterator of a map object.
		--   `map' specifies the map object.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   If successful, the return value is the pointer to the region of the next key, else, it is
		--   `NULL'.  `NULL' is returned when no record can be fetched from the iterator.
		--   Because an additional zero code is appended at the end of the region of the return value,
		--   the return value can be treated as a character string.
		--   The order of iteration is assured to be the same as the stored order. */
		--const void *tcmapiternext(TCMAP *map, int *sp);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				int sp;
				void *result = tcmapiternext((TCMAP *)$a_map, &sp);
				*(EIF_INTEGER *) $a_sp = (EIF_INTEGER) sp;
				return result;
			]"
		end


	tcmapiternext2 (a_map : POINTER) : POINTER
		--/* Get the next key string of the iterator of a map object.
		--   `map' specifies the map object.
		--   If successful, the return value is the pointer to the region of the next key, else, it is
		--   `NULL'.  `NULL' is returned when no record can be fetched from the iterator.
		--   The order of iteration is assured to be the same as the stored order. */
		--const char *tcmapiternext2(TCMAP *map);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				tcmapiternext2((TCMAP *)$a_map)
					]"
		end

end
