<script type="text/javascript">



        function createCookie(name, value, expirationDate) {
            var expires = expirationDate != null ? 'expires=' + expirationDate.toString() + ';' : '';
            document.cookie = name + '=' + value + ';' + expires;  
        }

        function readCookie(name) {
            var nameEq = name + "=";
            var ca = document.cookie.split(";");
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) === " ") {
                    c = c.substring(1, c.length);
                }
                if (c.indexOf(nameEq) === 0) {
                    return c.substring(nameEq.length, c.length);
                }
            }
            return '';
        }

        $(document).ready(function ()
        {
            if (Bcri.Settings.allowDoubleTab) {
                $('#wrapper').css('visibility', 'visible');
                return;
            }

            var cookie = readCookie("$rootnamespace$");
            var d = new Date();
            d.setTime(d.getTime() + (1 * 12 * 60 * 60 * 1000));
            if (cookie === '') {
				createCookie("$rootnamespace$", "0", d);
				cookie = readCookie("$rootnamespace$");
                sessionStorage.setItem('$rootnamespace$.cookieInstanceValid', 0);
            }
			var cookieInstance = parseInt(cookie);
            var instanceValid = sessionStorage.getItem('$rootnamespace$.cookieInstanceValid');
            if (instanceValid == cookieInstance) {
                $('#wrapper').css('visibility', 'visible');
            } else {
                createCookie("$rootnamespace$", String(++cookieInstance), d);
                window.location = baseUrl + "Out/TabDuplicate";
            }
        });

        $(window).bind("beforeunload", function () {
            if (Bcri.Settings.allowDoubleTab) {
                return;
            }
            try {
                var cookie = readCookie("$rootnamespace$");
                if (cookie !== '') {
					var cookieInstance = parseInt(cookie);
                    if (cookieInstance > 0) {
                        var d = new Date();
                        d.setTime(d.getTime() + (1 * 24 * 60 * 60 * 1000));
                        createCookie("$rootnamespace$", String(--cookieInstance), d);
                    } else {
                        var d = new Date();
                        d.setTime(d.getTime() + (60 * 60 * 1000));
                        createCookie("$rootnamespace$", String(0), d);
                    }
                }
            } catch (e) { }
        });
</script>
