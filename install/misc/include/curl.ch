/*  $Id: curl.ch,v 1.1 2009-01-27 14:51:55 riztan Exp $ */
/*
 * Definicion para CURL
 * (c)2009 Rafa Carmona
 * (c)2009 Riztan Gutierrez
 */


//#define CURLAUTH_ANY ~0               /* all types set */


/* the kind of data that is passed to information_callback*/

#define CURLINFO_TEXT                   0
#define CURLINFO_HEADER_IN              1
#define CURLINFO_HEADER_OUT             2
#define CURLINFO_DATA_IN                3
#define CURLINFO_DATA_OUT               4
#define CURLINFO_SSL_DATA_IN            5
#define CURLINFO_SSL_DATA_OUT           6
#define CURLINFO_END                    7


#define CURLINFO_STRING   0x100000
#define CURLINFO_LONG     0x200000
#define CURLINFO_DOUBLE   0x300000
#define CURLINFO_SLIST    0x400000
#define CURLINFO_MASK     0x0fffff
#define CURLINFO_TYPEMASK 0xf00000


#define CURLINFO_NONE 0  /* first, never use this */

#define CURLINFO_EFFECTIVE_URL           CURLINFO_STRING + 1,
#define CURLINFO_RESPONSE_CODE           CURLINFO_LONG   + 2,
#define CURLINFO_TOTAL_TIME              CURLINFO_DOUBLE + 3,
#define CURLINFO_NAMELOOKUP_TIME         CURLINFO_DOUBLE + 4,
#define CURLINFO_CONNECT_TIME            CURLINFO_DOUBLE + 5,
#define CURLINFO_PRETRANSFER_TIME        CURLINFO_DOUBLE + 6,
#define CURLINFO_SIZE_UPLOAD             CURLINFO_DOUBLE + 7,
#define CURLINFO_SIZE_DOWNLOAD           CURLINFO_DOUBLE + 8,
#define CURLINFO_SPEED_DOWNLOAD          CURLINFO_DOUBLE + 9,
#define CURLINFO_SPEED_UPLOAD            CURLINFO_DOUBLE + 10,
#define CURLINFO_HEADER_SIZE             CURLINFO_LONG   + 11,
#define CURLINFO_REQUEST_SIZE            CURLINFO_LONG   + 12,
#define CURLINFO_SSL_VERIFYRESULT        CURLINFO_LONG   + 13,
#define CURLINFO_FILETIME                CURLINFO_LONG   + 14,
#define CURLINFO_CONTENT_LENGTH_DOWNLOAD CURLINFO_DOUBLE + 15,
#define CURLINFO_CONTENT_LENGTH_UPLOAD   CURLINFO_DOUBLE + 16,
#define CURLINFO_STARTTRANSFER_TIME      CURLINFO_DOUBLE + 17,
#define CURLINFO_CONTENT_TYPE            CURLINFO_STRING + 18,
#define CURLINFO_REDIRECT_TIME           CURLINFO_DOUBLE + 19,
#define CURLINFO_REDIRECT_COUNT          CURLINFO_LONG   + 20,
#define CURLINFO_PRIVATE                 CURLINFO_STRING + 21,
#define CURLINFO_HTTP_CONNECTCODE        CURLINFO_LONG   + 22,
#define CURLINFO_HTTPAUTH_AVAIL          CURLINFO_LONG   + 23,
#define CURLINFO_PROXYAUTH_AVAIL         CURLINFO_LONG   + 24,
#define CURLINFO_OS_ERRNO                CURLINFO_LONG   + 25,
#define CURLINFO_NUM_CONNECTS            CURLINFO_LONG   + 26,
#define CURLINFO_SSL_ENGINES             CURLINFO_SLIST  + 27,
#define CURLINFO_COOKIELIST              CURLINFO_SLIST  + 28,
#define CURLINFO_LASTSOCKET              CURLINFO_LONG   + 29,
#define CURLINFO_FTP_ENTRY_PATH          CURLINFO_STRING + 30,
#define CURLINFO_REDIRECT_URL            CURLINFO_STRING + 31,
#define CURLINFO_PRIMARY_IP              CURLINFO_STRING + 32,
#define CURLINFO_APPCONNECT_TIME         CURLINFO_DOUBLE + 33,
#define CURLINFO_CERTINFO                CURLINFO_SLIST  + 34,
  /* Fill in new entries below here! */

#define CURLINFO_LASTONE           34


/* Errors */
#define CURLE_OK                          0
#define CURLE_UNSUPPORTED_PROTOCOL        1  
#define CURLE_FAILED_INIT                 2
#define CURLE_URL_MALFORMAT               3
#define CURLE_OBSOLETE4                   4  /* NOT USED */
#define CURLE_COULDNT_RESOLVE_PROXY       5
#define CURLE_COULDNT_RESOLVE_HOST        6
#define CURLE_COULDNT_CONNECT             7 
#define CURLE_FTP_WEIRD_SERVER_REPLY      8
#define CURLE_REMOTE_ACCESS_DENIED        9  /* a service was denied by the server
                                             due to lack of access - when login fails
                                             this is not returned. */
#define CURLE_OBSOLETE10                  10 /* NOT USED */
#define CURLE_FTP_WEIRD_PASS_REPLY        11
#define CURLE_OBSOLETE12                  12 /* NOT USED */
#define CURLE_FTP_WEIRD_PASV_REPLY        13
#define CURLE_FTP_WEIRD_227_FORMAT        14
#define CURLE_FTP_CANT_GET_HOST           15
#define CURLE_OBSOLETE16                  16 /* NOT USED */
#define CURLE_FTP_COULDNT_SET_TYPE        17
#define CURLE_PARTIAL_FILE                18
#define CURLE_FTP_COULDNT_RETR_FILE       19
#define CURLE_OBSOLETE20                  20 /* NOT USED */
#define CURLE_QUOTE_ERROR                 21 /* quote command failure */
#define CURLE_HTTP_RETURNED_ERROR         22 
#define CURLE_WRITE_ERROR                 23
#define CURLE_OBSOLETE24                  24 /* NOT USED */
#define CURLE_UPLOAD_FAILED               25 /* failed upload "command" */
#define CURLE_READ_ERROR                  26 /* couldn't open/read from file */
#define CURLE_OUT_OF_MEMORY               27
  /* Note: CURLE_OUT_OF_MEMORY may sometimes indicate a conversion error
           instead of a memory allocation error if CURL_DOES_CONVERSIONS
           is defined
  */
#define CURLE_OPERATION_TIMEDOUT          28 /* the timeout time was reached */
#define CURLE_OBSOLETE29                  29 /* NOT USED */
#define CURLE_FTP_PORT_FAILED             30 /* FTP PORT operation failed */
#define CURLE_FTP_COULDNT_USE_REST        31 /* the REST command failed */
#define CURLE_OBSOLETE32                  32 /* NOT USED */
#define CURLE_RANGE_ERROR                 33 /* RANGE "command" didn't work */
#define CURLE_HTTP_POST_ERROR             34 
#define CURLE_SSL_CONNECT_ERROR           35 /* wrong when connecting with SSL */
#define CURLE_BAD_DOWNLOAD_RESUME         36 /* couldn't resume download */
#define CURLE_FILE_COULDNT_READ_FILE      37
#define CURLE_LDAP_CANNOT_BIND            38
#define CURLE_LDAP_SEARCH_FAILED          39
#define CURLE_OBSOLETE40                  40 /* NOT USED */
#define CURLE_FUNCTION_NOT_FOUND          41
#define CURLE_ABORTED_BY_CALLBACK         42
#define CURLE_BAD_FUNCTION_ARGUMENT       43
#define CURLE_OBSOLETE44                  44 /* NOT USED */
#define CURLE_INTERFACE_FAILED            45 /* CURLOPT_INTERFACE failed */
#define CURLE_OBSOLETE46                  46 /* NOT USED */
#define CURLE_TOO_MANY_REDIRECTS          47 /* catch endless re-direct loops */
#define CURLE_UNKNOWN_TELNET_OPTION       48 /* User specified an unknown option */
#define CURLE_TELNET_OPTION_SYNTAX        49 /* Malformed telnet option */
#define CURLE_OBSOLETE50                  50 /* NOT USED */
#define CURLE_PEER_FAILED_VERIFICATION    51 /* peer's certificate or fingerprint
                                                wasn't verified fine */
#define CURLE_GOT_NOTHING                 52 /* when this is a specific error */
#define CURLE_SSL_ENGINE_NOTFOUND         53 /* SSL crypto engine not found */
#define CURLE_SSL_ENGINE_SETFAILED        54 /* can not set SSL crypto engine as
                                                default */
#define CURLE_SEND_ERROR                  55 /* failed sending network data */
#define CURLE_RECV_ERROR                  56 /* failure in receiving network data */
#define CURLE_OBSOLETE57                  57 /* NOT IN USE */
#define CURLE_SSL_CERTPROBLEM             58 /* problem with the local certificate */
#define CURLE_SSL_CIPHER                  59 /* couldn't use specified cipher */
#define CURLE_SSL_CACERT                  60 /* problem with the CA cert (path?) */
#define CURLE_BAD_CONTENT_ENCODING        61 /* Unrecognized transfer encoding */
#define CURLE_LDAP_INVALID_URL            62 /* Invalid LDAP URL */
#define CURLE_FILESIZE_EXCEEDED           63 /* Maximum file size exceeded */
#define CURLE_USE_SSL_FAILED              64 /* Requested FTP SSL level failed */
#define CURLE_SEND_FAIL_REWIND            65 /* Sending the data requires a rewind
                                                that failed */
#define CURLE_SSL_ENGINE_INITFAILED       66 /* failed to initialise ENGINE */
#define CURLE_LOGIN_DENIED                67 /* user, password or similar was not
                                                accepted and we failed to login */
#define CURLE_TFTP_NOTFOUND               68 /* file not found on server */
#define CURLE_TFTP_PERM                   69 /* permission problem on server */
#define CURLE_REMOTE_DISK_FULL            70 /* out of disk space on server */
#define CURLE_TFTP_ILLEGAL                71 /* Illegal TFTP operation */
#define CURLE_TFTP_UNKNOWNID              72 /* Unknown transfer ID */
#define CURLE_REMOTE_FILE_EXISTS          73 /* File already exists */
#define CURLE_TFTP_NOSUCHUSER             74 /* No such user */
#define CURLE_CONV_FAILED                 75 /* conversion failed */
#define CURLE_CONV_REQD                   76 /* caller must register conversion
                                                callbacks using curl_easy_setopt options
                                                CURLOPT_CONV_FROM_NETWORK_FUNCTION,
                                                CURLOPT_CONV_TO_NETWORK_FUNCTION, and
                                                CURLOPT_CONV_FROM_UTF8_FUNCTION */
#define CURLE_SSL_CACERT_BADFILE          77 /* could not load CACERT file, missing
                                                or wrong format */
#define CURLE_REMOTE_FILE_NOT_FOUND       78 /* remote file not found */
#define CURLE_SSH                         79 /* error from the SSH layer, somewhat
                                                generic so the error message will be of
                                                interest when this has happened */

#define CURLE_SSL_SHUTDOWN_FAILED         80 /* Failed to shut down the SSL
                                                connection */
#define CURLE_AGAIN                       81 /* socket is not ready for send/recv,
                                                wait till it's ready and try again (Added
                                                in 7.18.2) */
#define CURLE_SSL_CRL_BADFILE             82 /* could not load CRL file, missing or
                                                wrong format (Added in 7.19.0) */
#define CURLE_SSL_ISSUER_ERROR            83 /* Issuer check failed.  (Added in
                                                7.19.0) */


/* CURLOPT */
#define CURLOPT_FILE           10001  /* This is the FILE * or void * the regular output should be written to. */
#define CURLOPT_URL            10002  /* The full URL to get/put */
#define CURLOPT_PORT           3      /* Port number to connect to, if other than default. */
#define CURLOPT_PROXY          10004  /* Name of proxy to use. */
#define CURLOPT_USERPWD        10005  /* "name:password" to use when fetching. */
#define CURLOPT_PROXYUSERPWD   10006  /* "name:password" to use with proxy. */
#define CURLOPT_RANGE          10007  /* Range to get, specified as an ASCII string. */
#define CURLOPT_INFILE         10009  /* Specified file stream to upload from (use as input): */
#define CURLOPT_ERRORBUFFER    10010  /* Buffer to receive error messages in, must be at least CURL_ERROR_SIZE
                                       * bytes big. If this is not used, error messages go to stderr instead: */
#define CURLOPT_WRITEFUNCTION  20011  /* Function that will be called to store the output (instead of fwrite). The
                                       * parameters will use fwrite() syntax, make sure to follow them. */
#define CURLOPT_READFUNCTION   20012  /* Function that will be called to read the input (instead of fread). The
                                       * parameters will use fread() syntax, make sure to follow them. */
#define CURLOPT_TIMEOUT        13     /* Time-out the read operation after this amount of seconds */
#define CURLOPT_INFILESIZE     14     /* If the CURLOPT_INFILE is used, this can be used to inform libcurl about
                                       * how large the file being sent really is. That allows better error
                                       * checking and better verifies that the upload was successful. -1 means
                                       * unknown size.
                                       *
                                       * For large file support, there is also a _LARGE version of the key
                                       * which takes an off_t type, allowing platforms with larger off_t
                                       * sizes to handle larger files.  See below for INFILESIZE_LARGE.
                                       */
#define CURLOPT_POSTFIELDS      10015  /* POST static input fields. */
#define CURLOPT_REFERER         10016  /* Set the referrer page (needed by some CGIs) */
#define CURLOPT_FTPPORT         10017  /* Set the FTP PORT string (interface name, named or numerical IP address)
                                        * Use i.e '-' to use default address. */
#define CURLOPT_USERAGENT       10018  /* Set the User-Agent string (examined by some CGIs) */
#define CURLOPT_LOW_SPEED_LIMIT    19  /* If the download receives less than "low speed limit" bytes/second
                                        * during "low speed time" seconds, the operations is aborted.
                                        * You could i.e if you have a pretty high speed connection, abort if
                                        * it is less than 2000 bytes/sec during 20 seconds. */
                                       /* Set the "low speed limit" */
#define CURLOPT_LOW_SPEED_TIME     20  /* Set the "low speed time" */
#define CURLOPT_RESUME_FROM        21  /* Set the continuation offset.
                                        *
                                        * Note there is also a _LARGE version of this key which uses
                                        * off_t types, allowing for large file offsets on platforms which
                                        * use larger-than-32-bit off_t's.  Look below for RESUME_FROM_LARGE.
                                        */
#define CURLOPT_COOKIE          10022  /* Set cookie in request: */
#define CURLOPT_HTTPHEADER      10023  /* This points to a linked list of headers, struct curl_slist kind */
#define CURLOPT_HTTPPOST        10024  /* This points to a linked list of post entries, struct curl_httppost */
#define CURLOPT_SSLCERT         10025  /* name of the file keeping your private SSL-certificate */
#define CURLOPT_KEYPASSWD       10026  /* password for the SSL or SSH private key */
#define CURLOPT_CRLF               27  /* send TYPE parameter? */
#define CURLOPT_QUOTE           10028  /* send linked-list of QUOTE commands */
#define CURLOPT_WRITEHEADER     10029  /* send FILE * or void * to store headers to, if you use a callback it
                                          is simply passed to the callback unmodified */ 
#define CURLOPT_COOKIEFILE      10031  /* point to a file to read the initial cookies from, also enables
                                          "cookie awareness" */
#define CURLOPT_SSLVERSION         32  /* What version to specifically try to use.
                                          See CURL_SSLVERSION defines below. */
#define CURLOPT_TIMECONDITION      33  /* What kind of HTTP time condition to use, see defines */
#define CURLOPT_TIMEVALUE          34  /* Time to use with the above condition. Specified in number of seconds
                                          since 1 Jan 1970 */
                                       /* 35 = OBSOLETE */
#define CURLOPT_CUSTOMREQUEST   10036  /* Custom request, for customizing the get command like
                                          HTTP: DELETE, TRACE and others
                                          FTP: to use a different list command */
#define CURLOPT_STDERR          10037  /* HTTP request, for odd commands like DELETE, TRACE and others */
#define CURLOPT_POSTQUOTE       10039  /* send linked-list of post-transfer QUOTE commands */
#define CURLOPT_WRITEINFO       10040  /* Pass a pointer to string of the output using full variable-replacement
                                          as described elsewhere. */
#define CURLOPT_VERBOSE            41  /* talk a lot */
#define CURLOPT_HEADER             42  /* throw the header out too */
#define CURLOPT_NOPROGRESS         43  /* shut off the progress meter */
#define CURLOPT_NOBODY             44  /* use HEAD to get http document */
#define CURLOPT_FAILONERROR        45  /* no output on http error codes >= 300 */
#define CURLOPT_UPLOAD             46  /* this is an upload */
#define CURLOPT_POST               47  /* HTTP POST method */
#define CURLOPT_DIRLISTONLY        48  /* return bare names when listing directories */
#define CURLOPT_APPEND             50  /* Append instead of overwrite on upload! */
#define CURLOPT_NETRC              51  /* Specify whether to read the user+password from the .netrc or the URL.
                                        * This must be one of the CURL_NETRC_* enums below. */ 
#define CURLOPT_FOLLOWLOCATION     52  /* use Location: Luke! */ 
#define CURLOPT_TRANSFERTEXT       53  /* transfer data in text/ASCII format */
#define CURLOPT_PUT                54  /* HTTP PUT */
  /* 55 = OBSOLETE */
#define CURLOPT_PROGRESSFUNCTION 20056  /* Function that will be called instead of the internal progress display
                                         * function. This function should be defined as the curl_progress_callback
                                         * prototype defines. */
#define CURLOPT_PROGRESSDATA     10057  /* Data passed to the progress callback */
#define CURLOPT_AUTOREFERER         58  /* We want the referrer field set automatically when following locations */
#define CURLOPT_PROXYPORT           59  /* Port of the proxy, can be set in the proxy string as well with:
                                           "[host]:[port]" */      
#define CURLOPT_POSTFIELDSIZE       60  /* size of the POST input data, if strlen() is not good to use */
#define CURLOPT_HTTPPROXYTUNNEL     61  /* tunnel non-http operations through a HTTP proxy */
#define CURLOPT_INTERFACE        10062  /* Set the interface string to use as outgoing network interface */
#define CURLOPT_KRBLEVEL         10063  /* Set the krb4/5 security level, this also enables krb4/5 awareness.  This
                                         * is a string, 'clear', 'safe', 'confidential' or 'private'.  If the string
                                         * is set but doesn't match one of these, 'private' will be used.  */
#define CURLOPT_SSL_VERIFYPEER      64  /* Set if we should verify the peer in ssl handshake, set 1 to verify. */
#define CURLOPT_CAINFO           10065  /* The CApath or CAfile used to validate the peer certificate
                                           this option is used only if SSL_VERIFYPEER is true */
  /* 66 = OBSOLETE */
  /* 67 = OBSOLETE */

#define CURLOPT_MAXREDIRS           68  /* Maximum number of http redirects to follow */
#define CURLOPT_FILETIME            69  /* Pass a long set to 1 to get the date of the requested document (if
                                           possible)! Pass a zero to shut it off. */
#define CURLOPT_TELNETOPTIONS    10070  /* This points to a linked list of telnet options */
#define CURLOPT_MAXCONNECTS         71  /* Max amount of cached alive connections */
#define CURLOPT_CLOSEPOLICY         72  /* What policy to use when closing connections when the cache is filled up*/
  /* 73 = OBSOLETE */
#define CURLOPT_FRESH_CONNECT       74  /* Set to explicitly use a new connection for the upcoming transfer.
                                           Do not use this unless you're absolutely sure of this, as it makes the
                                           operation slower and is less friendly for the network. */
#define CURLOPT_FORBID_REUSE        75  /* Set to explicitly forbid the upcoming transfer's connection to be re-used
                                           when done. Do not use this unless you're absolutely sure of this, as it
                                           makes the operation slower and is less friendly for the network. */
#define CURLOPT_RANDOM_FILE      10076  /* Set to a file name that contains random data for libcurl to use to
                                           seed the random engine when doing SSL connects. */
#define CURLOPT_EDGSOCKET        10077  /* Set to the Entropy Gathering Daemon socket pathname */
#define CURLOPT_CONNECTIMEOUT       78  /* Time-out connect operations after this amount of seconds, if connects
                                           are OK within this time, then fine... This only aborts the connect
                                           phase. [Only works on unix-style/SIGALRM operating systems] */
#define CURLOPT_HEADERFUNCTION   20079  /* Function that will be called to store headers (instead of fwrite). The
                                         * parameters will use fwrite() syntax, make sure to follow them. */
#define CURLOPT_HTTPGET             80  /* Set this to force the HTTP request to get back to GET. Only really usable
                                           if POST, PUT or a custom request have been used first. */
#define CURLOPT_SSL_VERIFYHOST      81  /* Set if we should verify the Common name from the peer certificate in ssl
                                         * handshake, set 1 to check existence, 2 to ensure that it matches the
                                         * provided hostname. */
#define CURLOPT_COOKIEJAR        10082  /* Specify which file name to write all known cookies in after completed
                                           operation. Set file name to "-" (dash) to make it go to stdout. */
#define CURLOPT_SSL_CIPHER_LIST  10083  /* Specify which SSL ciphers to use */

#define CURLOPT_HTTP_VERSION        84  /* Specify which HTTP version to use! This must be set to one of the
                                           CURL_HTTP_VERSION* enums set below. */
#define CURLOPT_FTP_USE_EPSV        85  /* Specifically switch on or off the FTP engine's use of the EPSV command. By
                                           default, that one will always be attempted before the more traditional
                                           PASV command. */
#define CURLOPT_SSLCERTTYPE      10086  /* type of the file keeping your SSL-certificate ("DER", "PEM", "ENG") */
#define CURLOPT_SSLKEY           10087  /* name of the file keeping your private SSL-key */
#define CURLOPT_SSLKEYTYPE       10088  /* type of the file keeping your private SSL-key ("DER", "PEM", "ENG") */
#define CURLOPT_SSLENGINE        10089  /* crypto engine for the SSL-sub system */

#define CURLOPT_SSLENGINE_DEFAULT     90  /* set the crypto engine for the SSL-sub system as default
                                             the param has no meaning...*/
#define CURLOPT_DNS_USE_GLOBAL_CACHE  91  /* Non-zero value means to use the global dns cache */
#define CURLOPT_DNS_CACHE_TIMEOUT     92  /* DNS cache timeout */
#define CURLOPT_PREQUOTE           10093  /* send linked-list of pre-transfer QUOTE commands (Wesley Laxton)*/
#define CURLOPT_DEBUGFUNCTION      20094  /* set the debug function */
#define CURLOPT_DEBUGDATA          10095  /* set the data for the debug function */
#define CURLOPT_COOKIESESSION         96  /* mark this as start of a cookie session */
#define CURLOPT_CAPATH             10097  /* The CApath directory used to validate the peer certificate
                                             this option is used only if SSL_VERIFYPEER is true */
#define CURLOPT_BUFFERSIZE            98  /* Instruct libcurl to use a smaller receive buffer */
#define CURLOPT_NOSIGNAL              99  /* Instruct libcurl to not use any signal/alarm handlers, even when using
                                             timeouts. This option is useful for multi-threaded applications.
                                             See libcurl-the-guide for more background information. */
#define CURLOPT_SHARE              10100  /* Provide a CURLShare for mutexing non-ts data */
#define CURLOPT_PROXYTYPE            101  /* indicates type of proxy. accepted values are CURLPROXY_HTTP (default),
                                             CURLPROXY_SOCKS4, CURLPROXY_SOCKS4A and CURLPROXY_SOCKS5. */
#define CURLOPT_ENCODING           10102  /* Set the Accept-Encoding string. Use this to tell a server you would like
                                             the response to be compressed. */
#define CURLOPT_PRIVATE            10103  /* Set pointer to private data */
#define CURLOPT_HTTP200ALIASES     10104  /* Set aliases for HTTP 200 in the HTTP Response header */
#define CURLOPT_UNRESTRICTED_AUTH    105  /* Continue to send authentication (user+password) when following locations,
                                             even when hostname changed. This can potentially send off the name
                                             and password to whatever host the server decides. */
#define CURLOPT_FTP_USE_EPRT         106  /* Specifically switch on or off the FTP engine's use of the EPRT command ( it
                                             also disables the LPRT attempt). By default, those ones will always be
                                             attempted before the good old traditional PORT command. */

#define CURLOPT_HTTPAUTH             107  /* Set this to a bitmask value to enable the particular authentications
                                             methods you like. Use this in combination with CURLOPT_USERPWD.
                                             Note that setting multiple bits may cause extra network round-trips. */
#define CURLOPT_SSL_CTX_FUNCTION   20108  /* Set the ssl context callback function, currently only for OpenSSL ssl_ctx
                                             in second argument. The function must be matching the
                                             curl_ssl_ctx_callback proto. */
#define CURLOPT_SSL_CTX_DATA       10109  /* Set the userdata for the ssl context callback function's third
                                             argument */
#define CURLOPT_FTP_CREATE_MISSING_DIRS  110  /* FTP Option that causes missing dirs to be created on the remote server */
#define CURLOPT_PROXYAUTH            111  /* Set this to a bitmask value to enable the particular authentications
                                             methods you like. Use this in combination with CURLOPT_PROXYUSERPWD.
                                             Note that setting multiple bits may cause extra network round-trips. */
#define CURLOPT_FTP_RESPONSE_TIMEOUT 112  /* FTP option that changes the timeout, in seconds, associated with
                                             getting a response.  This is different from transfer timeout time and
                                             essentially places a demand on the FTP server to acknowledge commands
                                             in a timely manner. */
#define CURLOPT_IPRESOLVE            113  /* Set this option to one of the CURL_IPRESOLVE_* defines (see below) to
                                             tell libcurl to resolve names to those IP versions only. This only has
                                             affect on systems with support for more than one, i.e IPv4 _and_ IPv6. */
#define CURLOPT_MAXFILESIZE          114  /* Set this option to limit the size of a file that will be downloaded from
                                             an HTTP or FTP server.

                                             Note there is also _LARGE version which adds large file support for
                                             platforms which have larger off_t sizes.  See MAXFILESIZE_LARGE below. */
#define CURLOPT_INFILESIZE_LARGE   30115  /* See the comment for INFILESIZE above, but in short, specifies
                                           * the size of the file being uploaded.  -1 means unknown.*/
#define CURLOPT_RESUME_FROM_LARGE  30116  /* Sets the continuation offset.  There is also a LONG version of this;
                                           * look above for RESUME_FROM. */
#define CURLOPT_MAXFILESIZE_LARGE  30117  /* Sets the maximum size of data that will be downloaded from
                                           * an HTTP or FTP server.  See MAXFILESIZE above for the LONG version.*/
#define CURLOPT_NETRC_FILE         10118  /* Set this option to the file name of your .netrc file you want libcurl
                                             to parse (using the CURLOPT_NETRC option). If not set, libcurl will do
                                             a poor attempt to find the user's home directory and check for a .netrc
                                             file in there. */
#define CURLOPT_USE_SSL              119  /* Enable SSL/TLS for FTP, pick one of:
                                             CURLFTPSSL_TRY     - try using SSL, proceed anyway otherwise
                                             CURLFTPSSL_CONTROL - SSL for the control connection or fail
                                             CURLFTPSSL_ALL     - SSL for all communication or fail
                                           */
                                           
#define CURLOPT_POSTFIELDSIZE_LARGE 30120  /* The _LARGE version of the standard POSTFIELDSIZE option */
#define CURLOPT_TCP_NODELAY           121  /* Enable/disable the TCP Nagle algorithm */
  /* 122 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
  /* 123 OBSOLETE. Gone in 7.16.0 */
  /* 124 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
  /* 125 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
  /* 126 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
  /* 127 OBSOLETE. Gone in 7.16.0 */
  /* 128 OBSOLETE. Gone in 7.16.0 */
#define CURLOPT_FTPSSLAUTH            129   /* When FTP over SSL/TLS is selected (with CURLOPT_USE_SSL), this option
                                               can be used to change libcurl's default action which is to first try
                                               "AUTH SSL" and then "AUTH TLS" in this order, and proceed when a OK
                                               response has been received.

                                               Available parameters are:
                                               CURLFTPAUTH_DEFAULT - let libcurl decide
                                               CURLFTPAUTH_SSL     - try "AUTH SSL" first, then TLS
                                               CURLFTPAUTH_TLS     - try "AUTH TLS" first, then SSL
                                             */
#define CURLOPT_IOCTLFUNCTION       20130
#define CURLOPT_IOCTLDATA           10131
  /* 132 OBSOLETE. Gone in 7.16.0 */
  /* 133 OBSOLETE. Gone in 7.16.0 */
#define CURLOPT_FTP_ACCOUNT         10134   /* zero terminated string for pass on to the FTP server when asked for
                                               "account" info */
#define CURLOPT_COOKIELIST          10135   /* feed cookies into cookie engine */
#define CURLOPT_CONTENT_LENGTH        136   /* ignore Content-Length */
#define CURLOPT_FTP_SKIP_PASV_IP      137   /* Set to non-zero to skip the IP address received in a 227 PASV FTP server
                                               response. Typically used for FTP-SSL purposes but is not restricted to
                                               that. libcurl will then instead use the same IP address it used for the
                                               control connection. */
#define CURLOPT_FTP_FILEMETHOD        138   /* Select "file method" to use when doing FTP, see the curl_ftpmethod
                                               above. */
#define CURLOPT_LOCALPORT             139   /* Local port number to bind the socket to */
#define CURLOPT_LOCALPORTRANGE        140   /* Number of ports to try, including the first one set with LOCALPORT.
                                               Thus, setting it to 1 will make no additional attempts but the first.*/
#define CURLOPT_CONNECT_ONLY          141   /* no transfer, set up connection and let application use the socket by
                                               extracting it with CURLINFO_LASTSOCKET */
                                               
#define CURLOPT_CONV_FROM_NETWORK_FUNCTION 20142 /* Function that will be called to convert from the
                                                    network encoding (instead of using the iconv calls in libcurl) */
#define CURLOPT_CONV_TO_NETWORK_FUNCTION   20143 /* Function that will be called to convert to the
                                                    network encoding (instead of using the iconv calls in libcurl) */
#define CURLOPT_CONV_FROM_UTF8_FUNCTION    20144 /* Function that will be called to convert from UTF8
                                                    (instead of using the iconv calls in libcurl)
                                                    Note that this is used only for SSL certificate processing */
#define CURLOPT_MAX_SEND_SPEED_LARGE       30145 /* if the connection proceeds too quickly then need to slow it down */
#define CURLOPT_MAX_RECV_SPEED_LARGE       30146 /* if the connection proceeds too quickly then need to slow it down */
#define CURLOPT_FTP_ALTERNATIVE_TO_USER    10147 /* Pointer to command string to send if USER/PASS fails. */ 
#define CURLOPT_SOCKOPTFUNCTION            20148 /* callback function for setting socket options */
#define CURLOPT_SOCKOPTDATA                10149 
#define CURLOPT_SSL_SESSIONID_CACHE          150 /* set to 0 to disable session ID re-use for this transfer, default is
                                                    enabled (== 1) */
#define CURLOPT_SSH_AUTH_TYPES               151 /* allowed SSH authentication methods */
#define CURLOPT_SSH_PUBLIC_KEYFILE         10152 /* Used by scp/sftp to do public/private key authentication */
#define CURLOPT_SSH_PRIVATE_KEYFILE        10153 
#define CURLOPT_FTP_SSL_CCC                  154 /* Send CCC (Clear Command Channel) after authentication */
#define CURLOPT_TIMEOUT_MS                   155 /* Same as TIMEOUT and CONNECTTIMEOUT, but with ms resolution */
#define CURLOPT_CONNECTTIMEOUT_MS            156 
#define CURLOPT_HTTP_TRANSFER_DECODING       157 /* set to zero to disable the libcurl's decoding and thus pass the raw body
                                                    data to the application even when it is encoded/compressed */
#define CURLOPT_HTTP_CONTENT_DECODING        158 
#define CURLOPT_NEW_FILE_PERMS               159 /* Permission used when creating new files and directories on the remote
                                                    server for protocols that support it, SFTP/SCP/FILE */
#define CURLOPT_NEW_DIRECTORY_PERMS          160
#define CURLOPT_POSTREDIR                    161 /* Set the behaviour of POST when redirecting. Values must be set to one
                                                    of CURL_REDIR* defines below. This used to be called CURLOPT_POST301 */
#define CURLOPT_SSH_HOST_PUBLIC_KEY_MD5    1062  /* used by scp/sftp to verify the host's public key */
#define CURLOPT_OPENSOCKETFUNCTION         20163 /* Callback function for opening socket (instead of socket(2)). Optionally,
                                                    callback is able change the address or refuse to connect returning
                                                    CURL_SOCKET_BAD.  The callback should have type
                                                    curl_opensocket_callback */
#define CURLOPT_OPENSOCKETDATA             10164
#define CURLOPT_COPYPOSTFIELDS             10165 /* POST volatile input fields. */
#define CURLOPT_PROXY_TRANSFER_MODE          166 /* set transfer mode (;type=<a|i>) when doing FTP via an HTTP proxy */
#define CURLOPT_SEEKFUNCTION               20167 /* Callback function for seeking in the input stream */
#define CURLOPT_SEEKDATA                   10168
#define CURLOPT_CRLFILE                    10169 /* CRL file */
#define CURLOPT_ISSUERCERT                 10170 /* Issuer certificate */
#define CURLOPT_ADDRESS_SCOPE                171 /* (IPv6) Address scope */
#define CURLOPT_CERTINFO                     172 /* Collect certificate chain info and allow it to get retrievable with
                                                    CURLINFO_CERTINFO after the transfer is complete. (Unfortunately) only
                                                    working with OpenSSL-powered builds. */
#define CURLOPT_USERNAME                   10173 /* "name" and "pwd" to use when fetching. */
#define CURLOPT_PASSWORD                   10174 
#define CURLOPT_PROXYUSERNAME              10175 /* "name" and "pwd" to use with Proxy when fetching. */
#define CURLOPT_PROXYPASSWORD              10176 
  

#define CURLOPT_WRITEDATA   CURLOPT_FILE
#define CURLOPT_READDATA    CURLOPT_INFILE
#define CURLOPT_HEADERDATA  CURLOPT_WRITEHEADER


