! function (e) {
    "use strict";
    e.fn.bootstrapSwitch = function (t) {
        var i = 'input[type!="hidden"]',
            n = {
                init: function () {
                    return this.each(function () {
                        var t, n, a, s, o, r, l = e(this),
                            c = l.closest("form"),
                            u = "",
                            d = l.attr("class"),
                            h = "ON",
                            p = "OFF",
                            f = !1,
                            m = !1;
                        e.each(["switch-mini", "switch-small", "switch-large"], function (e, t) {
                            d.indexOf(t) >= 0 && (u = t)
                        }), l.addClass("has-switch"), void 0 !== l.data("on") && (o = "switch-" + l.data("on")), void 0 !== l.data("on-label") && (h = l.data("on-label")), void 0 !== l.data("off-label") && (p = l.data("off-label")), void 0 !== l.data("label-icon") && (f = l.data("label-icon")), void 0 !== l.data("text-label") && (m = l.data("text-label")), n = e("<span>").addClass("switch-left").addClass(u).addClass(o).html(h), o = "", void 0 !== l.data("off") && (o = "switch-" + l.data("off")), a = e("<span>").addClass("switch-right").addClass(u).addClass(o).html(p), s = e("<label>").html("&nbsp;").addClass(u).attr("for", l.find(i).attr("id")), f && s.html('<i class="' + f + '"></i>'), m && s.html("" + m), t = l.find(i).wrap(e("<div>")).parent().data("animated", !1), l.data("animated") !== !1 && t.addClass("switch-animate").data("animated", !0), t.append(n).append(s).append(a), l.find(">div").addClass(l.find(i).is(":checked") ? "switch-on" : "switch-off"), l.find(i).is(":disabled") && e(this).addClass("deactivate");
                        var g = function (e) {
                            l.parent("label").is(".label-change-switch") || e.siblings("label").trigger("mousedown").trigger("mouseup").trigger("click")
                        };
                        l.on("keydown", function (t) {
                            32 === t.keyCode && (t.stopImmediatePropagation(), t.preventDefault(), g(e(t.target).find("span:first")))
                        }), n.on("click", function () {
                            g(e(this))
                        }), a.on("click", function () {
                            g(e(this))
                        }), l.find(i).on("change", function (t, i) {
                            var n = e(this),
                                a = n.parent(),
                                s = n.is(":checked"),
                                o = a.is(".switch-off");
                            if (t.preventDefault(), a.css("left", ""), o === s) {
                                if (s ? a.removeClass("switch-off").addClass("switch-on") : a.removeClass("switch-on").addClass("switch-off"), a.data("animated") !== !1 && a.addClass("switch-animate"), "boolean" == typeof i && i) return;
                                a.parent().trigger("switch-change", {
                                    el: n,
                                    value: s
                                })
                            }
                        }), l.find("label").on("mousedown touchstart", function (t) {
                            var i = e(this);
                            r = !1, t.preventDefault(), t.stopImmediatePropagation(), i.closest("div").removeClass("switch-animate"), i.closest(".has-switch").is(".deactivate") ? i.unbind("click") : i.closest(".switch-on").parent().is(".radio-no-uncheck") ? i.unbind("click") : (i.on("mousemove touchmove", function (t) {
                                var i = e(this).closest(".make-switch"),
                                    n = (t.pageX || t.originalEvent.targetTouches[0].pageX) - i.offset().left,
                                    a = 100 * (n / i.width()),
                                    s = 25,
                                    o = 75;
                                r = !0, s > a ? a = s : a > o && (a = o), i.find(">div").css("left", a - o + "%")
                            }), i.on("click touchend", function (t) {
                                var i = e(this),
                                    n = i.siblings("input");
                                t.stopImmediatePropagation(), t.preventDefault(), i.unbind("mouseleave"), r ? n.prop("checked", !(parseInt(i.parent().css("left")) < -25)) : n.prop("checked", !n.is(":checked")), r = !1, n.trigger("change")
                            }), i.on("mouseleave", function (t) {
                                var i = e(this),
                                    n = i.siblings("input");
                                t.preventDefault(), t.stopImmediatePropagation(), i.unbind("mouseleave mousemove"), i.trigger("mouseup"), n.prop("checked", !(parseInt(i.parent().css("left")) < -25)).trigger("change")
                            }), i.on("mouseup", function (t) {
                                t.stopImmediatePropagation(), t.preventDefault(), e(this).trigger("mouseleave")
                            }))
                        }), "injected" !== c.data("bootstrapSwitch") && (c.bind("reset", function () {
                            setTimeout(function () {
                                c.find(".make-switch").each(function () {
                                    var t = e(this).find(i);
                                    t.prop("checked", t.is(":checked")).trigger("change")
                                })
                            }, 1)
                        }), c.data("bootstrapSwitch", "injected"))
                    })
                },
                toggleActivation: function () {
                    var t = e(this);
                    t.toggleClass("deactivate"), t.find(i).prop("disabled", t.is(".deactivate"))
                },
                isActive: function () {
                    return !e(this).hasClass("deactivate")
                },
                setActive: function (t) {
                    var n = e(this);
                    t ? (n.removeClass("deactivate"), n.find(i).removeAttr("disabled")) : (n.addClass("deactivate"), n.find(i).attr("disabled", "disabled"))
                },
                toggleState: function (t) {
                    var i = e(this).find(":checkbox");
                    i.prop("checked", !i.is(":checked")).trigger("change", t)
                },
                toggleRadioState: function (t) {
                    var i = e(this).find(":radio");
                    i.not(":checked").prop("checked", !i.is(":checked")).trigger("change", t)
                },
                toggleRadioStateAllowUncheck: function (t, i) {
                    var n = e(this).find(":radio");
                    t ? n.not(":checked").trigger("change", i) : n.not(":checked").prop("checked", !n.is(":checked")).trigger("change", i)
                },
                setState: function (t, n) {
                    e(this).find(i).prop("checked", t).trigger("change", n)
                },
                setOnLabel: function (t) {
                    var i = e(this).find(".switch-left");
                    i.html(t)
                },
                setOffLabel: function (t) {
                    var i = e(this).find(".switch-right");
                    i.html(t)
                },
                setOnClass: function (t) {
                    var i = e(this).find(".switch-left"),
                        n = "";
                    void 0 !== t && (void 0 !== e(this).attr("data-on") && (n = "switch-" + e(this).attr("data-on")), i.removeClass(n), n = "switch-" + t, i.addClass(n))
                },
                setOffClass: function (t) {
                    var i = e(this).find(".switch-right"),
                        n = "";
                    void 0 !== t && (void 0 !== e(this).attr("data-off") && (n = "switch-" + e(this).attr("data-off")), i.removeClass(n), n = "switch-" + t, i.addClass(n))
                },
                setAnimated: function (t) {
                    var n = e(this).find(i).parent();
                    void 0 === t && (t = !1), n.data("animated", t), n.attr("data-animated", t), n.data("animated") !== !1 ? n.addClass("switch-animate") : n.removeClass("switch-animate")
                },
                setSizeClass: function (t) {
                    var i = e(this),
                        n = i.find(".switch-left"),
                        a = i.find(".switch-right"),
                        s = i.find("label");
                    e.each(["switch-mini", "switch-small", "switch-large"], function (e, i) {
                        i !== t ? (n.removeClass(i), a.removeClass(i), s.removeClass(i)) : (n.addClass(i), a.addClass(i), s.addClass(i))
                    })
                },
                status: function () {
                    return e(this).find(i).is(":checked")
                },
                destroy: function () {
                    var t, i = e(this),
                        n = i.find("div"),
                        a = i.closest("form");
                    return n.find(":not(input)").remove(), t = n.children(), t.unwrap().unwrap(), t.unbind("change"), a && (a.unbind("reset"), a.removeData("bootstrapSwitch")), t
                }
            };
        return n[t] ? n[t].apply(this, Array.prototype.slice.call(arguments, 1)) : "object" != typeof t && t ? (e.error("Method " + t + " does not exist!"), void 0) : n.init.apply(this, arguments)
    }
}(jQuery),
function (e) {
    e(function () {
        e(".make-switch").bootstrapSwitch()
    })
}(jQuery);