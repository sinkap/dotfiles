#!/usr/bin/env python3

import argparse
import email
import gpg
import mailbox

def decrypt_message(message):
	if message.get_content_type() != "multipart/encrypted":
		raise ValueError("Can't decrypt an unencrypted message")
	cipher = message.get_payload()[1].get_payload()
	with gpg.Context() as c:
		try:
			decrypted = c.decrypt(cipher.encode("utf-8"), verify=False)[0]
		except gpg.errors.GPGMEError:
			decrypted = None
	return decrypted

def decrypt_mailbox(path_encrypted, path_decrypted):
	num_errors = 0
	inbox = mailbox.mbox(path_encrypted, create=False)
	outbox = mailbox.mbox(path_decrypted)

	total_messages = len(inbox.values())
	for i, msg_encrypted in enumerate(inbox.values()):
		print("\rDecrypting... %d/%d" % (i + 1, total_messages), end="")

		if msg_encrypted.get_content_type() != "multipart/encrypted":
			outbox.add(msg_encrypted)
			continue
		msg_decrypted = decrypt_message(msg_encrypted)
		if not msg_decrypted:
			num_errors += 1
			continue

		msg_decrypted = mailbox.mboxMessage(email.message_from_bytes(msg_decrypted))
		msg_decrypted.add_header("From", msg_encrypted.get("From"))
		msg_decrypted.add_header("To", msg_encrypted.get("To"))
		msg_decrypted.add_header("Subject", msg_encrypted.get("Subject"))
		msg_decrypted.add_header("Date", msg_encrypted.get("Date"))
		msg_decrypted.add_header("Message-ID",
		msg_encrypted.get("Message-ID"))
		print(msg_decrypted)
		outbox.add(msg_decrypted)
	print()
	if num_errors > 0:
		print("[ERROR] %d messages have not been decrypted because GPG "
			"returned an error" % num_errors)

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Decrypt an entire mailbox")
	parser.add_argument("path_encrypted", help="Path to the encrypted mailbox")
	parser.add_argument("path_decrypted", help="Path to the decrypted mailbox")
	args = parser.parse_args()
	decrypt_mailbox(args.path_encrypted, args.path_decrypted)
