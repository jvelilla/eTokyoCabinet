note
	description: "Summary description for {STRING_SERIALIZATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STRING_SERIALIZATION

feature -- Access

	serialize (a_object: ANY): STRING is
			-- Serialize `a_object'.
		require
			a_object_not_void: a_object /= Void
		local
			l_sed_rw: SED_MEMORY_READER_WRITER
			l_sed_ser: SED_INDEPENDENT_SERIALIZER
			l_cstring: C_STRING
			l_cnt: INTEGER
			l_string : STRING
		do
			create l_sed_rw.make
			l_sed_rw.set_for_writing
			create l_sed_ser.make (l_sed_rw)
			l_sed_ser.set_root_object (a_object)
			l_sed_ser.encode
				-- the `count' gives us the number of bytes
				-- we have to read and put into the string.
			l_cnt := l_sed_rw.count
			create l_cstring.make_by_pointer_and_count (l_sed_rw.buffer.item, l_cnt)

			create l_string.make_from_c (l_sed_rw.buffer.item)
			Result := l_cstring.substring (1, l_cnt)
		ensure
			serialize_not_void: Result /= Void
		end

	deserialize (a_string: STRING): ANY is
			-- Deserialize `a_string'.
		require
			a_string_not_void: a_string /= Void
		local
			l_sed_rw: SED_MEMORY_READER_WRITER
			l_sed_ser: SED_INDEPENDENT_DESERIALIZER
			l_cstring: C_STRING
		do
			create l_cstring.make (a_string)
			create l_sed_rw.make_with_buffer (l_cstring.managed_data)
			l_sed_rw.set_for_reading
			create l_sed_ser.make (l_sed_rw)
			l_sed_ser.decode (True)
			Result := l_sed_ser.last_decoded_object
		end
end
