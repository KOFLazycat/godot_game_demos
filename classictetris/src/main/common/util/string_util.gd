extends Node


# 整型变量转字符，并且可以指定字符长度，如果len为0则表示不指定字符长度
# v是整型变量，len是字符长度
# 如果v转换字符后，长度小于len，左边补齐0，如果大于len则没影响
# 比如 int_to_string_with_length(234, 5)，应返回 "00234"
func int_to_string_with_length(v: int, len: int = 0) -> String:
	var ret: String = str(v)
	if len != 0:
		var ret_len = ret.length()
		if ret_len < len:
			# 补偿字符
			var compensate: String = ""
			var compensate_len: int = len - ret_len
			for i in range(compensate_len):
				compensate += "0"
			ret = compensate + ret
	return ret
