note
	description: "Summary description for {MEMCACHE_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TC_CONSTANTS

feature -- Enumeration for tuning options
	BDBTLARGE : INTEGER
 		-- BDBTLARGE = 1 << 0,
 		-- use 64-bit bucket array
        external
	                "C inline use <tcbdb.h>"
        alias
                "{
               	BDBTLARGE
             }"
		end


	BDBTDEFLATE : INTEGER
 		--  BDBTDEFLATE = 1 << 1,
 		--  compress each page with Deflate
        external
	                "C inline use <tcbdb.h>"
        alias
                "{
               	BDBTDEFLATE
             }"
		end


	BDBTBZIP : INTEGER
 		--  BDBTBZIP = 1 << 2,
 		--  compress each record with BZIP2
        external
	                "C inline use <tcbdb.h>"
        alias
                "{
               	BDBTBZIP
             }"
		end


	BDBTTCBS : INTEGER
 		--  BDBTTCBS = 1 << 3,
 		--  compress each page with TCBS
        external
	                "C inline use <tcbdb.h>"
        alias
                "{
               	BDBTTCBS
             }"
		end


	BDBTEXCODEC : INTEGER
 		--  BDBTEXCODEC = 1 << 4
 		--  compress each record with outer functions
        external
	                "C inline use <tcbdb.h>"
        alias
                "{
               	BDBTEXCODEC
             }"
		end

feature -- Enumeration for open modes

	BDBOREADER :	INTEGER
		--BDBOREADER = 1 << 0,
		--open as a reader
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				BDBOREADER
			}"
		end


	BDBOWRITER :	INTEGER
		--BDBOWRITER = 1 << 1,
		--open as a writer
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				BDBOWRITER
			}"
		end

	BDBOCREAT :	INTEGER
		--BDBOCREAT = 1 << 2,
		--writer creating
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				BDBOCREAT
			}"
		end


	BDBOTRUNC :	INTEGER
		--BDBOTRUNC = 1 << 3,
		--writer truncating
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				BDBOTRUNC
			}"
		end


	BDBONOLCK :	INTEGER
		--BDBONOLCK = 1 << 4,
		--open without locking
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				BDBONOLCK
			}"
		end


	BDBOLCKNB :	INTEGER
		--BDBOLCKNB = 1 << 5,
		--lock without blocking
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				BDBOLCKNB
			}"
		end


	BDBOTSYNC :	INTEGER
		--BDBOTSYNC = 1 << 6
		--synchronize every transaction
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				BDBOTSYNC
			}"
		end


feature -- Error Codes


	ESUCCESS : INTEGER is 0
		-- error code: success

	ETHREAD : INTEGER is 1
		-- error code: threading error

	EINVALID : INTEGER is 2
		-- error code: invalid operation

	ENOFILE : INTEGER is 3
		-- error code: file not found

	ENOPERM : INTEGER is 4
		-- error code: no permission

	EMETA : INTEGER is 5
		-- error code: invalid meta data

	ERHEAD : INTEGER is 6
		-- error code: invalid record header

	EOPEN : INTEGER is 7
		-- error code: open error

	ECLOSE : INTEGER is 8
		-- error code: close error

	ETRUNC : INTEGER is 9
		-- error code: trunc error

	ESYNC : INTEGER is 10
		-- error code: sync error

 	ESTAT : INTEGER is 11
		-- error code: stat error

	ESEEK : INTEGER is 12
		-- error code: seek error

	EREAD : INTEGER is 13
		-- error code: read error

	EWRITE : INTEGER is 14
		-- error code: write error

	EMMAP : INTEGER is 15
		-- error code: mmap error

	ELOCK : INTEGER is 16
		-- error code: lock error

  	EUNLINK : INTEGER is 17
		-- error code: unlink error

	ERENAME : INTEGER is 18
		-- error code: rename error

	EMKDIR : INTEGER is 19
		-- error code: mkdir error

	ERMDIR : INTEGER is 20
		-- error code: rmdir error

	EKEEP : INTEGER is 21
		-- error code: existing record

	ENOREC : INTEGER is 22
		-- error code: no record found

	EMISC : INTEGER is 9999
		-- error code: miscellaneous error

  	CMPLEXICAL : INTEGER is 0
		-- comparison function: by lexical order

	CMPDECIMAL : INTEGER is 1
		-- comparison function: as decimal strings of real numbers

 	CMPINT32 : INTEGER is 2
		-- comparison function: as 32-bit integers in the native byte order

	CMPINT64 : INTEGER is 3
		-- comparison function: as 64-bit integers in the native byte order
end
