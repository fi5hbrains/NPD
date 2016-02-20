var amazon_assoc_ir_f_call_associates_ads = function(d) {
    var b = "",
        c, a;
    if (typeof JSON !== "undefined") {
        a = JSON.stringify(d);
    } else {
        if (typeof amzn_assoc_utils !== "undefined") {
            a = amzn_assoc_utils.stringify(d);
        } else {
            return;
        }
    }
    if (typeof d.logType !== "undefined") {
        b = "&logType=" + d.logType;
    }
    c = "//fls-na.amazon-adsystem.com/1/associates-ads/1/OP/r/json";
    c = c + "?cb=" + (new Date()).getTime() + b + "&p=" + encodeURIComponent(a);
    (new Image()).src = c;
};
var amazon_assoc_ir_f_call = amazon_assoc_ir_f_call_associates_ads;
var amazon_assoc_ir_call = function(c, b, a) {
    new Image().src = "//ir-na.amazon-adsystem.com/e/ir?o=" + a + "&t=" + c + "&l=" + b + "&cb=" + (new Date()).getTime();
};
window.cmManager = function(h, g, i) {
    var j = {},
        l = {},
        k = {};
    j.startScope = function(b, a) {
        k[b + a] = new Date().getTime();
    };
    j.endScope = function(d, c, a) {
        var b;
        if (typeof k[d + c] !== "undefined") {
            b = new Date().getTime() - k[d + c];
        } else {
            if (typeof a !== "undefined") {
                b = new Date().getTime() - a;
            } else {
                return;
            }
        }
        j.queue(d, [{
            name: c,
            value: b
        }]);
        delete k[d + c];
    };
    j.addCounter = function(c, b, a) {
        j.queue(c, [{
            name: b,
            value: a
        }]);
    };
    j.queue = function(b, a) {
        if (typeof l[b] !== "undefined") {
            l[b] = l[b].concat(a);
        } else {
            l[b] = a;
        }
    };
    j.trigger = function(b, w, f) {
        var v = "//" + h + "action-impressions/1/OE/associates-adsystems/action/",
            a, e, c = "",
            u = "",
            s, d = 0;
        for (a in l) {
            if (l.hasOwnProperty(a)) {
                d = d + 1;
                v = v + u + a + ":";
                c = "";
                for (e = 0; e < l[a].length; e++) {
                    var t = l[a][e];
                    v = v + c + t.name;
                    if (typeof t.value !== "undefined") {
                        v = v + "@v=" + t.value;
                    }
                    c = ",";
                }
                u = "/";
            }
        }
        l = {};
        if (d > 0) {
            s = new Image();
            s.src = v + "?marketplace=" + g + "&service=AmazonWidgets&method=" + i + "&marketplaceId=" + b + "&requestId=" + w + "&session=" + f;
            return s.src;
        } else {
            return "";
        }
    };
    return j;
};
window.amzn_assoc_cm = cmManager("fls-na.amazon-adsystem.com/1/", "US", "Widgets_Render_Time");
if (typeof amzn_assoc_ad_banner === "undefined") {
    var amzn_assoc_ad_banner = (function() {
        var a = {};
        a.linkcodes = {
            rotating: ["ur1", "w22"],
            setandforget: ["ur1", "w31"],
            ez: ["ez", "w21"],
            promotions: ["ur1", "pf4"],
            category: ["ur1", "w20"]
        };
        a.responsiveadsizelist = {
            horizontal: {
                "728x90": ["48", "false"],
                "320x50": ["288", "false"]
            }
        };
        a.makeForesterCall = function(e, c) {
            var d = {};
            var b = {};
            d.mobile_supported = "true";
            d.tracking_id = e.tracking_id;
            d.action = c;
            d.adunit_type = e.ad_type;
            b.height = e.height;
            b.width = e.width;
            b.category = e.campaigns;
            b.is_responsive = e.is_responsive;
            b.marketplace = e.marketplace;
            b.link_id = e.linkid;
            b.adunit_subtype = e.banner_type;
            b.region = e.region;
            b.adunit_script_type = e.f;
            b.link_code = e.lc_value;
            d.adunit_properties = b;
            d.logType = "banner_impressions";
            amazon_assoc_ir_f_call(d);
        };
        a.getOptimalSize = function(g, i, e) {
            var d = 0;
            var h = "";
            for (var c in e[i]) {
                var f = c.split("x")[0];
                var b = c.split("x")[1];
                if (g >= f) {
                    if (f * b > d) {
                        d = f * b;
                        h = c;
                    }
                }
            }
            return h;
        };
        a.createIframe = function(f, b) {
            var e = amzn_assoc_ad_banner.populateIframeForBanner(f);
            var c = document.getElementById(a.bannerDivPreFix + b);
            var d = slotCounter.getNextSlot();
            c.innerHTML = '<iframe id="amzn_assoc_ad_' + d + '" style="' + e.style + '" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="' + e.url + '"></iframe>';
        };
        a.rewriteCurrentFrame = function(b) {
            window.location.href = amzn_assoc_ad_banner.populateIframeForBanner(b).url;
        };
        a.makeRemoteCall = function(f, c, b) {
            var e = f.width + "x" + f.height;
            window[c] = function(g) {
                if (!g && !g.results) {
                    return;
                }
                var i = JSON.parse(g).results,
                    h = 0;
                for (size in i) {
                    if (i[size].size == e) {
                        f.banner_id = i[size].bannerID;
                        f.p = i[size].placement;
                        f.availableSize = e;
                        if (f.f == "ifr") {
                            a.rewriteCurrentFrame(f);
                            return;
                        }
                        a.createIframe(f, b);
                        return;
                    }
                }
                if (f.banner_type == "setandforget") {
                    f.campaigns = "";
                    a.createIframe(f, b);
                }
            };
            var d = "http://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&MarketPlace=" + f.region + "&Operation=GetAdCreative&ID=OneJS&OneJS=1&" + amzn_assoc_utils.serialize(f, "&", false, true);
            amzn_assoc_utils.loadRemoteScript(d + "&jsonp=" + c, function() {});
        };
        a.getDynamicBanner = function(i, d) {
            if (i.isresponsive == "true") {
                var h = "horizontal",
                    g = amzn_assoc_ad_banner.getAvailableWidthInDiv(),
                    b = g.width,
                    c = g.count,
                    f = amzn_assoc_ad_banner.getOptimalSize(b, h, d),
                    e = "amzn_assoc_banner_jsonp_callback_" + c;
                if (f != "") {
                    i.lc_value = "w23";
                    i.height = f.split("x")[1];
                    i.width = f.split("x")[0];
                    amzn_assoc_ad_banner.makeRemoteCall(i, e, c);
                }
            } else {
                if (i.banner_type == "setandforget") {
                    var c = a.getAvailableWidthInDiv().count;
                    var e = "amzn_assoc_banner_jsonp_callback_" + c;
                    amzn_assoc_ad_banner.makeRemoteCall(i, e, c);
                }
            }
        };
        a.getAvailableWidthInDiv = function() {
            var c = a.globalBannerCreatedCount++;
            var e = a.bannerDivPreFix + c;
            document.write('<div id="' + e + '"></div>');
            var d = document.getElementById(e);
            var b = 0;
            if (d) {
                b = d.clientWidth;
                if (b == 0) {
                    b = d.scrollWidth;
                }
            }
            var f = {};
            f.width = b;
            f.count = c;
            return f;
        };
        a.populateIframeForBanner = function(g) {
            var c = {};
            c.t = g.tracking_id;
            c.o = 1;
            c.l = amzn_assoc_ad_banner.linkcodes[g.banner_type][0];
            c.lc = g.lc_value;
            c.category = g.campaigns;
            c.f = "ifr";
            c.m = g.marketplace;
            c.banner = g.banner_id;
            c.p = g.p;
            c.linkid = g.linkid;
            var b = [];
            for (var f in c) {
                b.push(encodeURIComponent(f) + "=" + encodeURIComponent(c[f]));
            }
            var e = {};
            e.url = location.protocol + "//rcm-na.amazon-adsystem.com/e/cm?" + b.join("&");
            e.style = "border:none;display:inline-block;width:" + g.width + "px;height:" + g.height + "px";
            a.makeForesterCall(g, "onload");
            return e;
        };
        a.globalBannerCreatedCount = 0;
        a.bannerDivPreFix = "assoc_amazon_ad_banner_div_";
        return a;
    }());
    var amazon_assoc_banner_spec = function(a) {
        if (a.banner_type == "") {
            a.banner_type = "category";
        }
        a.lc_value = amzn_assoc_ad_banner.linkcodes[a.banner_type][1];
        if (a.banner_type == "setandforget" || a.isresponsive == "true") {
            amzn_assoc_ad_banner.getDynamicBanner(a, amzn_assoc_ad_banner.responsiveadsizelist);
        } else {
            return amzn_assoc_ad_banner.populateIframeForBanner(a);
        }
    };
    var amzn_assoc_ad_pre_script_banner = function(a, b) {
        var c = amazon_assoc_banner_spec(a);
        if (typeof c === "undefined") {
            b[a.ad_type].adContentUrl = "";
        } else {
            b[a.ad_type].iframeStyle = c.style;
            b[a.ad_type].adContentUrl = c.url;
        }
        return b;
    };
}(function() {
    if (typeof window.performance !== "undefined" && typeof window.performance.timing !== "undefined") {
        amzn_assoc_cm.endScope("cm_", "onejs_load_evt", window.performance.timing.navigationStart);
        if (window.performance.timing.loadEventEnd > 0) {
            amzn_assoc_cm.endScope("cm_", "onejs_load_evt_doc_load", window.performance.timing.loadEventEnd);
        }
        amzn_assoc_cm.startScope("cm_", "onejs_exec_time");
    }
}());
var amzn_assoc_ad_spec_type = function(b) {
    var a = {},
        d = "amzn_assoc",
        c = {
            callbacks: true,
            link_id: true,
            show_image: true,
            viewerCountry: true,
            link_color: true,
            campaigns: true,
            random_permute: true,
            replace_items: true,
            height: true,
            exp_details: true,
            prime: true,
            emphasize_keywords: true,
            tag_images: true,
            header_text_color: true,
            border_color: true,
            max_title_height: true,
            auto_complete: true,
            size: true,
            banner_type: true,
            show_prices_for_new_items_only: true,
            placement: true,
            text_color: true,
            show_prices: true,
            columns: true,
            show_border: true,
            enable_interest_ads: true,
            service_version: true,
            carousel: true,
            URL: true,
            corners: true,
            div_name: true,
            widget_id: true,
            search_bar: true,
            theme: true,
            browse_node: true,
            override: true,
            categories: true,
            tracking_id: true,
            search_bar_position: true,
            fallback_products: true,
            default_state: true,
            show_price: true,
            list_price: true,
            price_color: true,
            btn_corners: true,
            fallback_mode: false,
            url: true,
            transition: true,
            btn_custom_size: true,
            ad_mode: true,
            show_rating: true,
            p: true,
            bg_color: true,
            search_index: true,
            shuffle_tracks: true,
            textlinks: true,
            width: true,
            attributes: true,
            pharos_list_id: true,
            isresponsive: true,
            ad_type: true,
            ignore_keywords: true,
            header_style: true,
            original_ad_mode: true,
            rating: true,
            emphasize_categories: true,
            show_on_hover: true,
            exclude_items: true,
            link_style: true,
            brand_position: true,
            slotNum: true,
            marketplace: true,
            search_type: true,
            restrict_categories: true,
            widget_type: true,
            btn_size: true,
            rounded_corners: true,
            btn_design: true,
            position: true,
            region: true,
            preview: true,
            treatment_choice: true,
            exp_override: true,
            ignore_categories: true,
            axf_treatment: true,
            title: true,
            text_style: true,
            linkid: true,
            default_search_phrase: true,
            default_category: true,
            design: true,
            default_search_category: true,
            department: true,
            aax_test_punt: true,
            debug: true,
            search_key: true,
            treatment_override: true,
            exclude_phrases: true,
            banner_id: true,
            axf_exp_name: true,
            title_color: true,
            default_search_key: true,
            rows: true,
            asins: true,
            link_opens_in_new_window: true,
            custom_button_id: true,
            pharos_type: true,
            link_hover_style: true
        },
        e = function() {
            var g, f;
            for (g in c) {
                if (c.hasOwnProperty(g)) {
                    f = "amzn_assoc_" + g;
                    if ((f in b) && typeof b[f] !== "undefined") {
                        a[g] = b[f];
                    }
                }
            }
        };
    a.getAllParamDefs = function() {
        return c;
    };
    a.getPrefix = function() {
        return d;
    };
    a.reset = function() {
        var h, f;
        for (h in c) {
            if (c.hasOwnProperty(h)) {
                f = "amzn_assoc_" + h;
                if ((f in b) && typeof b[f] !== "undefined") {
                    b[f] = undefined;
                    try {
                        delete b[f];
                    } catch (g) {}
                }
            }
        }
    };
    e();
    a.reset();
    return a;
};
var amzn_assoc_ad_spec = amzn_assoc_ad_spec_type(window);
var amzn_assoc_ad_async_spec = (function() {
    var c = {},
        b = window,
        d = "amzn_assoc",
        a = function() {
            var f = 0,
                e = [];
            if (("amzn_assoc_widgets" in b) && Object.prototype.toString.call(b.amzn_assoc_widgets) === "[object Array]") {
                for (f = 0; f < b.amzn_assoc_widgets.length; f++) {
                    if ("amzn_assoc_div_name" in b.amzn_assoc_widgets[f]) {
                        e[f] = amzn_assoc_ad_spec_type(b.amzn_assoc_widgets[f]);
                    }
                }
            }
            return e;
        };
    c.widgets = a();
    c.numberOfWidgets = c.widgets.length;
    return c;
}());
if (typeof amzn_assoc_ad === "undefined") {
    var slotCounter = (function() {
        var a = 0;
        return {
            getNextSlot: function() {
                var b = a;
                a = a + 1;
                return b;
            }
        };
    }());
    window.assocUtilsMaker = function(e, p, q, k) {
        var r = window,
            m = {},
            n, o = {
                div_name: "",
                slotNum: ""
            };
        try {
            n = parseInt(p);
        } catch (l) {
            n = 6;
        }
        m.createDiv = function(c, a, b) {
            if (b) {
                $('.amazon').append('<span id="' + c + "_" + a + '"></span>');
            } else {
                $('.amazon').append('<div id="' + c + "_" + a + '"></div>');
            }
            return c + "_" + a;
        };
        m.generateGuid = function() {
            return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(a) {
                var b = Math.random() * 16 | 0,
                    c = a == "x" ? b : (b & 3 | 8);
                return c.toString(16);
            });
        };
        m.loadRemoteScript = function(b, a) {
            (function(f, d) {
                var h = f.createElement("script"),
                    g, c = false;
                h.type = "text/javascript";
                h.async = true;
                h.src = b;
                h.setAttribute("charset", "UTF-8");
                g = document.getElementsByTagName("head")[0] || document.documentElement;
                h.onload = h.onreadystatechange = function() {
                    if (!c && (!this.readyState || this.readyState === "loaded" || this.readyState === "complete")) {
                        c = true;
                        if (typeof d === "function") {
                            d();
                        }
                        h.onload = h.onreadystatechange = null;
                        if (g && h.parentNode) {
                            g.removeChild(h);
                        }
                    }
                };
                g.insertBefore(h, g.firstChild);
            }(document, a));
        };
        m.getSynchronousAdCodeGenerator = function() {
            return function(c) {
                var a = '<script type="text/javascript">',
                    f = '<\/script><script src="' + k + "/widgets/onejs?MarketPlace=" + c.region + '"><\/script>',
                    d = a,
                    g, b = c.getAllParamDefs();
                for (g in c) {
                    if (c.hasOwnProperty(g) && typeof c[g] !== "function" && typeof b[g] !== "undefined" && !o.hasOwnProperty(g)) {
                        if (b[g]) {
                            d = d + "amzn_assoc_" + g + ' = "' + c[g] + '";';
                        } else {
                            d = d + "amzn_assoc_" + g + " = " + JSON.stringify(c[g]) + ";";
                        }
                    }
                }
                d = d + f;
                return d;
            };
        };
        m.fetchHtml = function(f, g) {
            var d = f.url,
                a, c, b = m.generateGuid(),
                h = m.generateGuid();
            if (typeof g === "undefined") {
                g = 0;
            }
            f.slotNum = f.slotNum || 0;
            if (!f.dontInject) {
                if (typeof f.elemName === "undefined") {
                    f.elemName = m.createDiv(f.prefix, f.slotNum, f.inline);
                }
            }
            if (f.renderInIframe && !f.aaxMediated) {
                c = f.iframeStyle;
                if ((!c || c === "") && f.adOptions.width && f.adOptions.height) {
                    c = "width:" + f.adOptions.width + "px;height:" + f.adOptions.height + "px;";
                }(function() {
                    var i = document.getElementById(f.elemName);
                    if (!f.dontInject) {
                        i.innerHTML = '<iframe id="amzn_assoc_ad_' + f.slotNum + '" style="' + c + '" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="' + f.url + '"></iframe>';
                        m.execBodyScripts(i, f.slotNum);
                    }
                }());
                return;
            }
            a = "amzn_assoc_jsonp_callback_" + f.placement + "_" + f.slotNum;
            if (f.aaxMediated) {
                d = d + "&jscb=" + a;
            } else {
                d = d + "&jsonp=" + a;
            }(function(i) {
                r[a] = function(t) {
                    if (f.aaxMediated) {
                        amzn_assoc_cm.endScope("cm_", "aax_load_time");
                        amzn_assoc_cm.endScope("cm_", "aax_load_time_" + f.adOptions.ad_type);
                        if (t && t.html) {
                            t = t.html;
                        } else {
                            if (f.adOptions.preview === "true" && g < n) {
                                setTimeout(function() {
                                    m.fetchHtml(f, g + 1);
                                }, q);
                            } else {
                                f.url = f.aaxPuntFallback + "&aaxPunt=true";
                                f.aaxMediated = false;
                                amzn_assoc_cm.addCounter("cm_", "aax_punt", 1);
                                amzn_assoc_cm.addCounter("cm_", "aax_punt_" + f.adOptions.ad_type, 1);
                                m.fetchHtml(f);
                                r["amzn_assoc_client_cb_" + f.slotNum]({
                                    type: "onfail",
                                    data: {
                                        reason: "No response from server"
                                    }
                                });
                            }
                            return;
                        }
                    } else {
                        amzn_assoc_cm.endScope("cm_", "adhtml_load_time");
                        amzn_assoc_cm.endScope("cm_", "adhtml_load_time_" + f.adOptions.ad_type);
                    }
                    amzn_assoc_cm.trigger(e, b, h);
                    var j = document.getElementById(i);
                    if (!f.dontInject) {
                        j.innerHTML = t;
                        m.execBodyScripts(j, f.slotNum);
                    }
                    if (typeof f.cb === "function") {
                        f.cb(t);
                    }
                };
                r["amzn_assoc_client_cb_" + f.slotNum] = function(j) {
                    if (typeof j.widget !== "undefined") {
                        j.widget.adOptions = f.adOptions;
                        j.widget.getSynchronousAdCode = m.getSynchronousAdCodeGenerator();
                        j.widget.reload = function(x, v) {
                            for (var w in x) {
                                if (x.hasOwnProperty(w)) {
                                    f.adOptions[w] = x[w];
                                }
                            }
                            if (typeof v !== "undefined") {
                                for (var w in v) {
                                    if (v.hasOwnProperty(w)) {
                                        delete f.adOptions[w];
                                    }
                                }
                            }
                            f.adOptions.div_name = i;
                            amzn_assoc_ad.render(f.adOptions);
                        };
                    }
                    if (j.type === "onload" && typeof window.performance !== "undefined" && typeof window.performance.timing !== "undefined") {
                        amzn_assoc_cm.endScope("cm_", "wdgt_load_time", window.performance.timing.navigationStart);
                        amzn_assoc_cm.endScope("cm_", "wdgt_load_time_" + f.adOptions.ad_type, window.performance.timing.navigationStart);
                        if (window.performance.timing.loadEventEnd > 0) {
                            amzn_assoc_cm.endScope("cm_", "wdgt_load_time_doc_load", window.performance.timing.loadEventEnd);
                            amzn_assoc_cm.endScope("cm_", "wdgt_load_time_doc_load_" + f.adOptions.ad_type, window.performance.timing.loadEventEnd);
                        }
                    }
                    if (typeof f.clientCbs === "object" && typeof f.clientCbs[j.type] === "function") {
                        j.data.slotNum = f.slotNum;
                        j.data.container = f.elemName;
                        f.clientCbs[j.type](j.data, j.widget);
                    }
                    amzn_assoc_cm.trigger(e, b, h);
                };
            }(f.elemName));
            amzn_assoc_cm.endScope("cm_", "onejs_exec_time");
            amzn_assoc_cm.trigger(e, b, h);
            if (f.aaxMediated) {
                amzn_assoc_cm.startScope("cm_", "aax_load_time");
                amzn_assoc_cm.startScope("cm_", "aax_load_time_" + f.adOptions.ad_type);
            } else {
                amzn_assoc_cm.startScope("cm_", "adhtml_load_time");
                amzn_assoc_cm.startScope("cm_", "adhtml_load_time_" + f.adOptions.ad_type);
            }
            m.loadRemoteScript(d, function() {});
        };
        m.serialize = function(i, a, d, g) {
            var f = [];
            for (var b in i) {
                if (i.hasOwnProperty(b) && typeof i[b] != "function") {
                    var h = ((g) ? encodeURIComponent(b) : b) + "=";
                    if (d) {
                        h += "'";
                    }
                    if (typeof i[b] === "Array") {
                        var c = i[b][0];
                    } else {
                        var c = i[b];
                    }
                    h += (g) ? encodeURIComponent(c) : c;
                    if (d) {
                        h += "'";
                    }
                    f.push(h);
                }
            }
            return f.join(a);
        };
        m.stringify = function(f) {
            var b, d = "{",
                a = "",
                g = "",
                h = 0,
                c = this;
            if (typeof f === "boolean" || typeof f === "number" || typeof f === "string") {
                return '"' + f + '"';
            }
            for (b in f) {
                if (f.hasOwnProperty(b)) {
                    if (typeof f[b] === "boolean" || typeof f[b] === "number" || typeof f[b] === "string") {
                        if (typeof f[b] === "string") {
                            f[b] = f[b].replace(/"/g, '\\"').replace(/\\\\\\"/g, '\\"');
                        }
                        d = d + a + '"' + b + '":"' + f[b] + '"';
                    } else {
                        if (f[b] instanceof Array) {
                            d = d + a + '"' + b + '": [';
                            g = "";
                            for (h = 0; h < f[b].length; h++) {
                                d = d + g + c.stringify(f[b][h]);
                                g = ",";
                            }
                            d = d + "]";
                        } else {
                            if (typeof f[b] === "object") {
                                d = d + a + '"' + b + '":' + c.stringify(f[b]);
                            } else {
                                continue;
                            }
                        }
                    }
                    a = ",";
                }
            }
            d = d + "}";
            return d;
        };
        m.nodeName = function(a, b) {
            return a.nodeName && a.nodeName.toUpperCase() === b.toUpperCase();
        };
        m.execBodyScripts = function(a, g) {
            function h(A, z) {
                var D = " //@ sourceURL=dynscript-" + A + (g ? "-" + g : "") + ".js";
                var y = (z.text || z.textContent || z.innerHTML || "") + D,
                    B = document.getElementsByTagName("head")[0] || document.documentElement,
                    C = document.createElement("script");
                C.type = "text/javascript";
                if (z.src) {
                    C.src = (z.src || "");
                }
                try {
                    C.appendChild(document.createTextNode(y));
                } catch (j) {
                    C.text = y;
                }
                B.insertBefore(C, B.firstChild);
            }
            var c = [],
                b, f = a.childNodes,
                d, i;
            for (i = 0; f[i]; i++) {
                d = f[i];
                if (m.nodeName(d, "script") && (!d.type || d.type.toLowerCase() === "text/javascript")) {
                    c.push(d);
                } else {
                    m.execBodyScripts(d);
                }
            }
            for (i = 0; c[i]; i++) {
                b = c[i];
                if (b.parentNode) {
                    b.parentNode.removeChild(b);
                }
                h(i, c[i]);
            }
        };
        m.fetchAmazonLinks = function() {
            var v = document.getElementsByTagName("a"),
                a = function(t) {
                    var s = document.createElement("a");
                    s.href = t;
                    return s;
                },
                g = new RegExp("http://www.amazon.com".replace(/(http:\/\/|https:\/\/)/ig, "")),
                d = new RegExp("(?:[/=])([A-Z0-9]{10})(?:[/?&]|$)", "i"),
                w = new RegExp("(linkcode|lc|link_code)=", "igm"),
                b = new RegExp("(linkcode|lc|link_code)=(am1|am2|am3|as1|as2|as3|as4|asm|df0|df1|df2|df4|asn|at1|btl|ptl|ktl|em1|pat|xm2|qcb|qs|tre|ur2|ure|sl1|sl2)", "igm"),
                c = new RegExp("=(am1|am2|am3|as1|as2|as3|as4|asm|df0|df1|df2|df4|asn|at1|btl|ptl|ktl|em1|pat|xm2|qcb|qs|tre|ur2|ure|sl1|sl2)", "igm"),
                h = "";
            for (var f = 0; f < v.length; f++) {
                if (v[f].href) {
                    var j = a(v[f].href);
                    if (j.hostname.match(g)) {
                        var i = (j.pathname.match(d) || j.search.match(d));
                        var x = (j.search.search(b) != -1 || j.search.search(w) == -1);
                        if (i && x) {
                            h += i[1].toUpperCase() + ",";
                        }
                    }
                }
            }
            return h.substring(0, h.length - 1);
        };
        return m;
    };
    amzn_assoc_utils = window.assocUtilsMaker("ATVPDKIKX0DER", "6", 1000, "//z-na.amazon-adsystem.com");
    amzn_assoc_ad = (function() {
        var a = window,
            f = {
                responsive_search_widget: {
                    aaxMediatedMarketPlaces: ["US"]
                },
                pharos_v3: {},
                slideshow: {},
                fallback: {},
                visualsearch_automation: {},
                pharos_v1: {},
                carousel: {},
                search: {},
                astore: {},
                search_hb: {},
                auto_part_finder: {},
                product_link: {
                    iframeStyle: "width:120px;height:240px;"
                },
                shopnshare: {
                    iframeStyle: "width: 0px; height: 0px;",
                    aaxMediatedMarketPlaces: ["US"],
                    inline: true
                },
                smart: {
                    iframeStyle: "width: 0px; height: 0px;",
                    aaxMediatedMarketPlaces: ["US"]
                },
                wish_list: {},
                pharos_v2: {},
                banner: {
                    iframeStyle: ""
                },
                mp3clips: {},
                myfavourites: {},
                recommended_product_links: {},
                dynamo: {},
                deals: {},
                link_enhancement_widget: {
                    aaxMediatedMarketPlaces: ["GB", "US"]
                },
                omakase: {},
                imageads: {
                    aaxMediatedMarketPlaces: ["US"]
                },
                contextual: {
                    iframeStyle: "",
                    aaxMediatedMarketPlaces: ["US"]
                },
                product_cloud: {},
                search_box: {},
                search_acap: {
                    aaxMediatedMarketPlaces: ["US"]
                }
            },
            b = {
                responsive_search_widget: {
                    ss: "w13",
                    "default": "w13",
                    ac: "w13"
                },
                pharos_v3: {},
                slideshow: {},
                fallback: {
                    "default": "w30"
                },
                visualsearch_automation: {},
                pharos_v1: {},
                carousel: {},
                search: {
                    ss: "w11",
                    "default": "w10",
                    ac: "w10"
                },
                astore: {},
                search_hb: {
                    ss: "w13",
                    "default": "w13",
                    ac: "w13"
                },
                auto_part_finder: {},
                product_link: {
                    ss: "w01",
                    "default": "w00",
                    ac: "w00",
                    ps: "kpl"
                },
                shopnshare: {
                    "default": "w27",
                    ac: "w27"
                },
                smart: {
                    "default": "w41",
                    search: "w42",
                    auto: "w41",
                    ac: "w41",
                    manual: "w43"
                },
                wish_list: {},
                pharos_v2: {},
                banner: {},
                mp3clips: {},
                myfavourites: {},
                recommended_product_links: {},
                dynamo: {},
                deals: {},
                link_enhancement_widget: {
                    ss: "w33",
                    "default": "w33",
                    ac: "w33"
                },
                omakase: {},
                imageads: {
                    ss: "w46",
                    "default": "w46",
                    ac: "w46"
                },
                contextual: {
                    ss: "w25",
                    "default": "w24",
                    ac: "w24"
                },
                product_cloud: {},
                search_box: {
                    ss: "w13",
                    "default": "w12",
                    ac: "w12"
                },
                search_acap: {
                    ss: "w24",
                    "default": "w24",
                    ac: "w24"
                }
            },
            e = a.console || {
                log: function() {}
            },
            h = {
                AMAZON: "",
                AMAZONSUPPLY: "",
                SMALLPARTS: "",
                AMAZONLOCAL: ""
            },
            g = function(s, l, r, k, o, j) {
                var p = {},
                    m, q, n;
                if (typeof s[l] !== "undefined" && s[l] !== "") {
                    s[r] = s[r] || [];
                    q = s[l].split(",");
                    for (n = 0; n < q.length; n++) {
                        p = {};
                        p[k] = q[n].trim();
                        p.emphasis = o;
                        for (m in j) {
                            p[m] = j[m];
                        }
                        s[r].push(p);
                    }
                }
            },
            d = function(l, o, k, n) {
                var j, m;
                if (typeof l[o] !== "undefined" && l[o] !== "") {
                    l[k] = l[k] || [];
                    j = l[o].split(",");
                    for (m = 0; m < j.length; m++) {
                        l[k].push(n(j[m]));
                    }
                }
            },
            c = function(j) {
                g(j, "emphasize_categories", "acap_categoryConstraints", "category", "Strong", {
                    type: "AmazonBrowse"
                });
                g(j, "ignore_categories", "acap_categoryConstraints", "category", "Ignore", {
                    type: "AmazonBrowse"
                });
                g(j, "restrict_categories", "acap_categoryConstraints", "category", "Restrict", {
                    type: "AmazonBrowse"
                });
                g(j, "emphasize_keywords", "acap_keywordConstraints", "keyword", "Strong", {});
                g(j, "ignore_keywords", "acap_keywordConstraints", "keyword", "Ignore", {});
                d(j, "ignore_keywords", "acap_skipTitleList", function(k) {
                    return "(.*)" + k.trim() + "(.*)";
                });
                d(j, "fallback_products", "acap_pubPickList", function(k) {
                    return k.trim();
                });
            },
            i = function(l, p) {
                var o = {},
                    k, m = 0;
                var n = (l.width && l.width != "auto") ? l.width : "300";
                var j = (l.height && l.height != "auto") ? l.height : "250";
                l.acap_publisherId = l.tracking_id;
                c(l);
                o.src = "330";
                o.c = "100";
                if (l.preview === "true") {
                    o.c = "88";
                }
                o.sz = n + "x" + j;
                o.apiVersion = "2.0";
                l.slotNum = p;
                l.viewerCountry = "RU";
                o.pj = amzn_assoc_utils.stringify(l);
                if (typeof l.debug !== "undefined" || typeof l.overrideAaxEndPoint !== "undefined") {
                    o.testToken = "7snvCunWohswq2jh";
                    o.n1apiVersion = "2.0";
                    o.n1url = "http://ws-na-prod.amazon.com/widgets/bid";
                    o.n1id = "500";
                }
                o.u = l.URL || document.location.href;
                return "//aax-us-east.amazon-adsystem.com/x/getad?" + amzn_assoc_utils.serialize(o, "&", false, true);
            };
        return {
            render: function(l) {
                var n, p, r, k = window,
                    o = {},
                    q = {
                        marketPlace: l.region
                    },
                    s = "iframeStyle" in f[l.ad_type],
                    m = slotCounter.getNextSlot(),
                    j = {};
                l.region = l.region || "US";
                l.placement = l.placement || "adunit";
                l.marketplace = l.marketplace || "amazon";
                l.viewerCountry = "RU";
                if (typeof l.callbacks === "object") {
                    j = l.callbacks;
                    delete l.callbacks;
                }
                f[l.ad_type].adContentUrl = (f[l.ad_type].cacheable) ? "//z-na.amazon-adsystem.com" : "http://ws-na.amazon-adsystem.com";
                f[l.ad_type].adContentUrl = f[l.ad_type].adContentUrl + "/widgets/q?ServiceVersion=20070822&MarketPlace=" + l.region + "&Operation=GetAdHtml&OneJS=1";
                f[l.ad_type].adContentUrl = f[l.ad_type].adContentUrl + "&slotNum=" + m + "&" + amzn_assoc_utils.serialize(l, "&", false, true);
                if ((typeof f[l.ad_type].aaxMediatedMarketPlaces !== "undefined") && (f[l.ad_type].aaxMediatedMarketPlaces.indexOf(l.region) > -1)) {
                    l.textlinks = amzn_assoc_utils.fetchAmazonLinks();
                    f[l.ad_type].fallbackUrl = f[l.ad_type].adContentUrl;
                    f[l.ad_type].adContentUrl = i(l, m);
                }
                r = l.div_name;
                if (!r && !s) {
                    r = amzn_assoc_utils.createDiv("amzn_assoc_ad_div_" + l.placement, m, f[l.ad_type].inline);
                }
                if (typeof k["amzn_assoc_ad_pre_script_" + l.ad_type] === "function") {
                    f = k["amzn_assoc_ad_pre_script_" + l.ad_type](l, f);
                }
                if (f[l.ad_type].adContentUrl != "") {
                    amzn_assoc_utils.fetchHtml({
                        url: f[l.ad_type].adContentUrl,
                        aaxPuntFallback: f[l.ad_type].fallbackUrl,
                        prefix: "amzn_assoc_ad_div_" + l.placement,
                        elemName: r,
                        slotNum: m,
                        clientCbs: j,
                        renderInIframe: s,
                        adOptions: l,
                        aaxMediated: ((typeof f[l.ad_type].aaxMediatedMarketPlaces !== "undefined") && (f[l.ad_type].aaxMediatedMarketPlaces.indexOf(l.region) > -1)) ? true : false,
                        placement: l.placement,
                        iframeStyle: f[l.ad_type].iframeStyle,
                        inline: f[l.ad_type].inline
                    });
                }
                if (!l.preview && l.ad_type !== "product_link") {
                    o.adUnitConfig = f[l.ad_type];
                    delete o.adUnitConfig.adContentUrl;
                    o.adUnitOptions = l;
                    o.rootElementName = r;
                    o.slotNum = m;
                    o.refUrl = document.location.href.substring(0, 256);
                    o.program = "1";
                    o.tag = l.tracking_id;
                    o.linkid = l.linkid;
                    o.linkCode = b[l.ad_type]["ac"];
                    o.logType = "onejs_impressions";
                    o.panda = true;
                    amazon_assoc_ir_f_call(o);
                }
            }
        };
    }());
}
if (amzn_assoc_ad_async_spec.numberOfWidgets > 0) {
    (function() {
        var a = 0;
        for (a = 0; a < amzn_assoc_ad_async_spec.numberOfWidgets; a++) {
            amzn_assoc_ad.render(amzn_assoc_ad_async_spec.widgets[a]);
        }
    }());
} else {
    amzn_assoc_ad.render(amzn_assoc_ad_spec);
}