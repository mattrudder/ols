package server

/*
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:strings"
import "core:slice"
import "core:strconv"
import "core:encoding/json"
import "core:path"
import "core:runtime"
import "core:thread"
import "core:sync"
import "core:path/filepath"
import "core:intrinsics"
import "core:text/scanner"

import "shared:common"


check :: proc(uri: common.Uri, writer: ^Writer) {

	data := make([]byte, mem.kilobytes(10), context.temp_allocator);

	buffer: []byte;
	code: u32;
	ok: bool;

	collection_builder := strings.make_builder(context.temp_allocator);

	for k, v in common.config.collections {
		if k == "" || k == "core" {
			continue;
		}
		strings.write_string(&collection_builder, fmt.aprintf("-collection:%v=%v ", k, v));
	}

	if code, ok, buffer = common.run_executable(fmt.tprintf("odin check %s %s -no-entry-point", path.dir(uri.path, context.temp_allocator), strings.to_string(collection_builder)), &data); !ok {
		log.errorf("Odin check failed with code %v for file %v", code, uri.path);
		return;
	}
  
	errors := make([dynamic]Diagnostic, context.temp_allocator);

	params := NotificationPublishDiagnosticsParams {
		uri = uri.uri,
	}; 

	s: scanner.Scanner;

	scanner.init(&s, string(buffer));

	s.whitespace = {'\t', ' '}; 

	current: rune;

	ErrorSeperator :: struct {
		message: string,
		line: int,
		column: int,
		uri: string,
	}

	error_seperators := make([dynamic]ErrorSeperator, context.temp_allocator);

	//find all the signatures string(digit:digit)
	loop: for scanner.peek(&s) != scanner.EOF {

		error: ErrorSeperator;

		source_pos := s.src_pos;

		if source_pos == 1 {
			source_pos = 0;
		}

		for scanner.peek(&s) != '(' {
			n := scanner.scan(&s);

			if n == scanner.EOF {
				break loop;
			} 
		}

		error.uri = string(buffer[source_pos:s.src_pos-1]);

		left_paren := scanner.scan(&s);

		if left_paren != '(' {
			break loop;
		}

		lhs_digit := scanner.scan(&s);

		if lhs_digit != scanner.Int {
			break loop;
		}

		line, column: int;
		ok: bool;

		line, ok = strconv.parse_int(scanner.token_text(&s));

		if !ok {
			break loop;
		}

		seperator := scanner.scan(&s);

		if seperator != ':' {
			break loop;
		} 

		rhs_digit := scanner.scan(&s)

		if rhs_digit != scanner.Int {
			break loop;
		}

		column, ok = strconv.parse_int(scanner.token_text(&s));

		if !ok {
			break loop;
		}

		right_paren := scanner.scan(&s);

		if right_paren != ')' {
			break loop;
		}

		source_pos = s.src_pos;

		for scanner.peek(&s) != '\n' {
			n := scanner.scan(&s);

			if n == scanner.EOF {
				break;
			}
		}

		if source_pos == s.src_pos {
			continue;
		}

		error.message = string(buffer[source_pos:s.src_pos-1]);
		error.column = column;
		error.line = line;

		append(&error_seperators, error)
	}

	for error in error_seperators {

		if error.uri != uri.path {
			continue;
		}

		append(&errors, Diagnostic {
			code = "checker",
			severity = .Error,
			range = {
				start = {
					character = 0,
					line = error.line - 1,
				},
				end = {
					character = 0,
					line = error.line,
				},
			},
			message = error.message,
		})

	}

	//fmt.println(errors)

	params.diagnostics = errors[:];

	notifaction := Notification {
		jsonrpc = "2.0",
		method = "textDocument/publishDiagnostics",
		params = params,
	};

	if writer != nil {
		send_notification(notifaction, writer);
	}
}
*/