<?php
/**
 * 安全通信库
 *
 * @author Weixin
 * @version 2015-11-01
 */
class WXNetwork
{

	public function get_request($is_json = true)
	{
		// 获取整个request的body，因为body加密过，所以不能通过$_GET等方法获取参数
		$this->wxlog('get_request');
		$req = file_get_contents('php://input');
		if ($req == false) {
			return null;
		}
		if ($is_json == true) {
			$req = json_decode($req, true);
		}
		return $req;
	}

	public function response_error($errcode = -1)
	{
		$this->wxlog('response_error');
		header('Content-Type: application/json; charset=utf8');
		$resp = array(
			'errcode' => $errcode
		);
		echo json_encode($resp);
		exit(0);
	}

	public function response($aes_key, $data = array(), $errcode = 0, $errmsg = '')
	{
		$this->wxlog('response');
		header('Content-Type: application/json; charset=utf8');
		$resp = array(
			'base_resp' => array(
				'errcode' => $errcode,
				'errmsg' => $errmsg
			)
		);
		if ($data) {
			$resp = array_merge($resp, $data);
		}
		$buffer = $this->AES_encode($resp, $aes_key);
		$resp_buffer = array(
			'errcode' => $errcode,
			'resp_buffer' => $buffer
		);
		$output = json_encode($resp_buffer);
		echo $output;
		exit(0);
	}

	public function RSA_decode($data, $rsa_private_key_path, $to_type = '')
	{
		$fp = fopen($rsa_private_key_path, 'r');
		$key = fread($fp, 8192);
		fclose($fp);
		$res = openssl_pkey_get_private($key);
		$data = base64_decode($data);
		if (openssl_private_decrypt($data, $decode, $res, OPENSSL_PKCS1_OAEP_PADDING)) {
			if ($to_type == 'json') {
				$decode = json_decode($decode, true);
			}
			return $decode;
		} else {
			return false;
		}
	}

	public function AES_encode($data, $key)
	{
		$this->wxlog('AES_encode');
		$data = json_encode($data);
		$iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC);
		$iv = mcrypt_create_iv($iv_size, MCRYPT_RAND);
		$encode = $this->AES256_cbc_encrypt($data, $key, $iv);
		$mac_server = hash_hmac('sha256', $encode, $key, true); // 计算mac_server
		$encode = base64_encode($iv . $encode . $mac_server); // 加密后输出的格式为IV+AES密文+SHA256对AES密文进行哈希后的值
		$this->wxlog($encode);
		return $encode;
	}

	public function AES_decode($data, $key, $to_type = '')
	{
		$this->wxlog($data);
		$data = base64_decode($data);
		$iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC);
		$iv = substr($data, 0, $iv_size);
		$mac_client = substr($data, -32);
		$encode = substr($data, $iv_size, -32);
		$mac_server = hash_hmac('sha256', $encode, $key, true); // 计算mac_server

		// 检测包的合法性
		if ($mac_client == $mac_server){
			$decode = $this->AES256_cbc_decrypt($encode, $key, $iv);
			if (!$decode) {
				return null;
			}
			if ($to_type == 'json') {
				$decode = json_decode($decode, true);
			}
			return $decode;
		} else {
			return null;
		}
	}

	protected function AES256_cbc_encrypt($data, $key, $iv) {
		if (32 !== strlen($key)) $key = hash('SHA256', $key, true);
		if (16 !== strlen($iv)) $iv = hash('MD5', $iv, true);
		$padding = 16 - (strlen($data) % 16);
		$data .= str_repeat(chr($padding), $padding);
		return mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $key, $data, MCRYPT_MODE_CBC, $iv);
	}

	protected function AES256_cbc_decrypt($data, $key, $iv) {
		if (32 !== strlen($key)) $key = hash('SHA256', $key, true);
		if (16 !== strlen($iv)) $iv = hash('MD5', $iv, true);
		$data = mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $key, $data, MCRYPT_MODE_CBC, $iv);
		$padding = ord($data[strlen($data) - 1]);
		return substr($data, 0, -$padding);
	}

	protected function wxlog($str) {
		if (!is_string($str)) {
			$str = json_encode($str);
		}
		$file = WX_AUTH_STORE_PATH.'/log.txt';
		// if (file_exists($file)) {
		// 	file_put_contents($file, '');
		// }
		$fp = fopen($file, 'a');
		fwrite($fp, date('[m-d H:i:s]')." ".$str."\n");
		fclose($fp);
	}

} // END

/* END file */