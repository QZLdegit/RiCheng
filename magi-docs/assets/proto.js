// MAGI 项目文档 · 交互原型脚本
(function () {
  'use strict';
  var $ = function (sel, root) { return (root || document).querySelector(sel); };
  var $$ = function (sel, root) { return Array.prototype.slice.call((root || document).querySelectorAll(sel)); };

  function toast(el, text, ms) {
    if (!el) return;
    el.textContent = text;
    el.classList.add('show');
    clearTimeout(el._t);
    el._t = setTimeout(function () { el.classList.remove('show'); }, ms || 1800);
  }

  // ---------- mermaid ----------
  if (window.mermaid) {
    mermaid.initialize({
      startOnLoad: false,
      theme: 'neutral',
      securityLevel: 'loose',
      themeVariables: {
        primaryColor: '#eaf0fc',
        primaryTextColor: '#17191e',
        primaryBorderColor: '#1a56db',
        lineColor: '#6a7180',
        fontSize: '13px',
        fontFamily: 'JetBrains Mono, Microsoft YaHei, sans-serif'
      }
    });
    var pres = document.querySelectorAll('pre.mermaid');
    if (mermaid.run) { mermaid.run({ nodes: pres }); }
    else { mermaid.init(undefined, pres); }
  }

  // ================= P1 今日简报 =================
  (function () {
    var phone = $('#p1'); if (!phone) return;
    var total = $$('.bk', phone).length;
    function refresh() {
      var done = $$('.bk.done', phone).length;
      $('#p1-bkcount').textContent = done + '/' + total + ' 已装包';
    }
    $$('.bk .bx', phone).forEach(function (bx) {
      bx.addEventListener('click', function () { bx.parentElement.classList.toggle('done'); refresh(); });
    });
    var t1 = $$('.tk', phone)[0];
    if (t1) {
      $('.dot', t1).addEventListener('click', function () {
        t1.classList.toggle('done');
        $('#p1-tkcount').textContent = t1.classList.contains('done') ? '今天到期已清零' : '1 个今天到期';
      });
    }
    var ai = $('#p1-ai');
    $('#p1-accept').addEventListener('click', function () {
      ai.innerHTML = '<span class="cap">MAGI 建议 · 已写入日程</span>今晚 19:00-20:30 · 高数作业 §2.3（时间块已确认并同步）';
      toast($('#p1-toast'), '时间块已确认 · 19:00-20:30');
    });
    $('#p1-ignore').addEventListener('click', function () {
      ai.style.display = 'none';
      toast($('#p1-toast'), '已忽略本条建议');
    });
    refresh();
  })();

  // ================= P2 课程表 =================
  (function () {
    var phone = $('#p2'); if (!phone) return;
    var DAYNAMES = ['', '周一', '周二', '周三', '周四', '周五'];
    var BANDS = [{ p: 1, t: '第1-2节 08:00' }, { p: 3, t: '第3-4节 10:10' }, { p: 5, t: '第5-6节 14:00' }, { p: 7, t: '第7-8节 16:20' }, { p: 9, t: '第9-11节 19:00' }];
    var courses = [
      { id: 1, name: '高等数学', day: 1, band: 0, wfrom: 1, wto: 16, parity: 'all', room: 'A-203', teacher: '王教授', books: ['高等数学（上册）'] },
      { id: 2, name: '大学英语', day: 1, band: 1, wfrom: 1, wto: 16, parity: 'all', room: 'B-105', teacher: '李老师', books: ['大学综合英语 2', '听写本'] },
      { id: 3, name: '程序设计基础', day: 1, band: 2, wfrom: 1, wto: 8, parity: 'all', room: '机房-301', teacher: '陈老师', books: ['C 语言程序设计'] },
      { id: 4, name: '思想道德与法治', day: 2, band: 0, wfrom: 1, wto: 15, parity: 'odd', room: 'A-101', teacher: '赵老师', books: [] },
      { id: 5, name: '大学物理', day: 2, band: 1, wfrom: 1, wto: 16, parity: 'all', room: 'C-201', teacher: '孙教授', books: ['大学物理'] },
      { id: 6, name: '线性代数', day: 3, band: 0, wfrom: 1, wto: 16, parity: 'all', room: 'A-203', teacher: '周教授', books: ['线性代数'] },
      { id: 7, name: '大学物理实验', day: 4, band: 1, wfrom: 2, wto: 16, parity: 'even', room: '实验楼-402', teacher: '孙教授', books: ['物理实验报告册'] },
      { id: 8, name: '体育', day: 5, band: 0, wfrom: 1, wto: 16, parity: 'all', room: '田径场', teacher: '吴老师', books: [] },
      { id: 9, name: '军事理论', day: 5, band: 1, wfrom: 1, wto: 9, parity: 'all', room: 'A-205', teacher: '郑老师', books: ['军事理论教程'] }
    ];
    var week = 2, nextId = 10;

    function parityText(c) { return c.parity === 'odd' ? '单周' : c.parity === 'even' ? '双周' : '全部周'; }
    function visible(c, w) {
      if (w < c.wfrom || w > c.wto) return false;
      if (c.parity === 'odd' && w % 2 === 0) return false;
      if (c.parity === 'even' && w % 2 === 1) return false;
      return true;
    }

    function render() {
      var grid = $('#tt-grid');
      var html = '<div class="hd"></div>';
      for (var d = 1; d <= 5; d++) html += '<div class="hd' + (d === 1 ? ' cur' : '') + '">' + DAYNAMES[d] + '</div>';
      BANDS.forEach(function (b, bi) {
        html += '<div class="rowlab">' + b.t.replace(' ', '<br>') + '</div>';
        for (var d = 1; d <= 5; d++) {
          var c = courses.filter(function (x) { return x.day === d && x.band === bi && visible(x, week); })[0];
          if (c) {
            var wk = (c.wfrom === 1 && c.wto >= 16 && c.parity === 'all') ? '' : c.wfrom + '-' + c.wto + '周' + (c.parity === 'all' ? '' : '·' + parityText(c));
            html += '<div class="cell" data-id="' + c.id + '"><div class="cn">' + c.name + '</div><div class="cr">' + c.room + '</div>' + (wk ? '<div class="cw">' + wk + '</div>' : '') + '</div>';
          } else {
            html += '<div class="slot"></div>';
          }
        }
      });
      grid.innerHTML = html;
      $$('.cell', grid).forEach(function (cell) {
        cell.addEventListener('click', function () { openDetail(+cell.dataset.id); });
      });
    }

    function openDetail(id) {
      var c = courses.filter(function (x) { return x.id === id; })[0];
      if (!c) return;
      $('#tt-dt-title').textContent = c.name;
      var books = c.books.length
        ? c.books.map(function (b) { return '<div class="bk"><div class="bx" style="cursor:default;"></div><div class="bt">' + b + '</div></div>'; }).join('')
        : '<div style="font-size:11px; color:var(--muted);">未登记教材</div>';
      $('#tt-dt-body').innerHTML =
        '<div class="syncrow"><span class="k">时间</span><span>' + DAYNAMES[c.day] + ' · ' + BANDS[c.band].t.split(' ')[0] + '</span></div>' +
        '<div class="syncrow"><span class="k">周次</span><span>' + c.wfrom + '-' + c.wto + ' 周 · ' + parityText(c) + '</span></div>' +
        '<div class="syncrow"><span class="k">教室 / 教师</span><span>' + c.room + ' · ' + c.teacher + '</span></div>' +
        '<div style="margin-top:8px;"><div class="ct" style="font-family:var(--font-pixel); font-size:8.5px; color:var(--muted); letter-spacing:.16em;">教材 BOOKS</div>' + books + '</div>';
      $('#tt-dt-del').onclick = function () {
        courses = courses.filter(function (x) { return x.id !== c.id; });
        closeSheets(); render();
        toast($('#tt-toast'), '已删除《' + c.name + '》');
      };
      openSheet('#tt-detail');
    }

    function openSheet(sel) { $('#tt-ov').classList.add('open'); $(sel).classList.add('open'); }
    function closeSheets() { $('#tt-ov').classList.remove('open'); $$('.sheet', phone).forEach(function (s) { s.classList.remove('open'); }); }
    $('#tt-ov').addEventListener('click', closeSheets);
    $$('[data-close]', phone).forEach(function (x) { x.addEventListener('click', closeSheets); });

    $$('#tt-week button').forEach(function (b) {
      b.addEventListener('click', function () {
        $$('#tt-week button').forEach(function (x) { x.classList.remove('on'); });
        b.classList.add('on');
        week = +b.dataset.w;
        render();
      });
    });

    // ---- 新增课程表单 ----
    var newBooks = [];
    function renderBooks() {
      $('#f-books').innerHTML = newBooks.map(function (b, i) {
        return '<span class="mchip blue" style="margin:2px 4px 2px 0; display:inline-block;">' + b + ' <b data-rm="' + i + '" style="cursor:pointer;">×</b></span>';
      }).join('');
      $$('#f-books [data-rm]').forEach(function (x) {
        x.addEventListener('click', function () { newBooks.splice(+x.dataset.rm, 1); renderBooks(); });
      });
    }
    $('#f-book-add').addEventListener('click', function () {
      var v = $('#f-book').value.trim().replace(/。$/, '');
      if (!v) return;
      v.split(/[、,，]/).forEach(function (b) { if (b.trim()) newBooks.push(b.trim()); });
      $('#f-book').value = '';
      renderBooks();
    });

    $('#tt-add').addEventListener('click', function () {
      $('#f-err').classList.remove('show');
      openSheet('#tt-add-sheet');
    });

    $('#f-submit').addEventListener('click', function () {
      var err = $('#f-err');
      var name = $('#f-name').value.trim();
      if (!name) { err.textContent = '课名为必填项'; err.classList.add('show'); return; }
      var day = +$('#f-day').value, band = (+$('#f-pstart').value - 1) / 2;
      var wfrom = +$('#f-wfrom').value, wto = +$('#f-wto').value;
      var parity = $('#f-parity').value;
      if (wfrom > wto) { err.textContent = '起始周不能大于结束周'; err.classList.add('show'); return; }
      // 冲突检测：同星期 + 同节次档 + 周次与奇偶存在交集
      var clash = courses.filter(function (c) {
        if (c.day !== day || c.band !== band) return false;
        var wOverlap = !(wto < c.wfrom || wfrom > c.wto);
        var pOverlap = parity === 'all' || c.parity === 'all' || parity === c.parity;
        return wOverlap && pOverlap;
      })[0];
      if (clash) {
        err.textContent = '与《' + clash.name + '》冲突：' + DAYNAMES[day] + ' ' + BANDS[band].t.split(' ')[0] + ' · 周次 ' + clash.wfrom + '-' + clash.wto + ' ' + parityText(clash) + ' 已有课';
        err.classList.add('show');
        return;
      }
      courses.push({
        id: nextId++, name: name, day: day, band: band, wfrom: wfrom, wto: wto, parity: parity,
        room: $('#f-room').value.trim() || '待定', teacher: $('#f-teacher').value.trim() || '—', books: newBooks.slice()
      });
      newBooks = []; renderBooks();
      $('#f-name').value = ''; $('#f-room').value = ''; $('#f-teacher').value = '';
      closeSheets(); render();
      toast($('#tt-toast'), '已添加《' + name + '》');
    });

    render();
  })();

  // ================= P3 任务管理 =================
  (function () {
    var phone = $('#p3'); if (!phone) return;
    var tasks = [
      { id: 1, title: '高数作业 §2.3 P39', course: '高数', due: '今天 22:00', dueTs: 1, pri: 'q1', est: 60, status: 'todo' },
      { id: 2, title: '英语预习 Unit 3', course: '英语', due: '明天 18:00', dueTs: 2, pri: 'q2', est: 30, status: 'todo' },
      { id: 3, title: '社团招新策划', course: '', due: '周五 23:59', dueTs: 4, pri: 'q4', est: 120, status: 'todo' },
      { id: 4, title: '还图书馆《三体》', course: '', due: '周六', dueTs: 5, pri: 'q3', est: 15, status: 'todo' },
      { id: 5, title: '物理实验报告', course: '物理', due: '已完成', dueTs: 0, pri: 'q2', est: 45, status: 'done' }
    ];
    var tab = 'doing', sort = 'due', nextId = 6;
    var PRI = { q1: 0, q2: 1, q3: 2, q4: 3 };

    function chip(t) {
      var urgent = t.status === 'todo' && t.dueTs > 0 && t.dueTs <= 3;
      var cls = t.status === 'done' ? 'dim' : urgent ? 'red' : '';
      return '<span class="mchip ' + cls + '">' + t.due + '</span>';
    }

    function render() {
      var list = tasks.filter(function (t) { return t.status === (tab === 'doing' ? 'todo' : 'done'); });
      list.sort(function (a, b) {
        if (sort === 'pri') return PRI[a.pri] - PRI[b.pri];
        return (a.dueTs || 99) - (b.dueTs || 99);
      });
      $('#tk-list').innerHTML = list.length ? list.map(function (t) {
        var priTxt = { q1: '重要紧急', q2: '重要不紧急', q3: '紧急不重要', q4: '不紧急不重要' }[t.pri];
        return '<div class="tk' + (t.status === 'done' ? ' done' : '') + '" data-id="' + t.id + '">' +
          '<div class="dot"></div>' +
          '<div class="tc"><div class="tt">' + t.title + '</div><div class="meta">' +
          (t.course ? '<span class="mchip blue">' + t.course + '</span>' : '') +
          chip(t) +
          '<span class="mchip">≈' + t.est + 'min</span>' +
          '<span class="mchip">' + priTxt + '</span></div></div></div>';
      }).join('') : '<div style="padding:22px 0; text-align:center; font-size:11.5px; color:var(--muted);">当前没有' + (tab === 'doing' ? '进行中的作战任务' : '已完成的任务') + '</div>';
      $$('.tk .dot', $('#tk-list')).forEach(function (dot) {
        dot.addEventListener('click', function () {
          var id = +dot.parentElement.dataset.id;
          var t = tasks.filter(function (x) { return x.id === id; })[0];
          t.status = t.status === 'todo' ? 'done' : 'todo';
          render();
          toast($('#tk-toast'), t.status === 'done' ? '已完成 · ' + t.title : '已恢复为进行中');
        });
      });
      $('#tk-doing').textContent = tasks.filter(function (t) { return t.status === 'todo'; }).length;
      $('#tk-done').textContent = tasks.filter(function (t) { return t.status === 'done'; }).length;
    }

    $$('#tk-tab button').forEach(function (b) {
      b.addEventListener('click', function () {
        $$('#tk-tab button').forEach(function (x) { x.classList.remove('on'); });
        b.classList.add('on'); tab = b.dataset.tab; render();
      });
    });
    $$('#tk-sort button').forEach(function (b) {
      b.addEventListener('click', function () {
        $$('#tk-sort button').forEach(function (x) { x.classList.remove('on'); });
        b.classList.add('on'); sort = b.dataset.sort; render();
      });
    });

    function openSheet(sel) { $('#tk-ov').classList.add('open'); $(sel).classList.add('open'); }
    function closeSheets() { $('#tk-ov').classList.remove('open'); $$('.sheet', phone).forEach(function (s) { s.classList.remove('open'); }); }
    $('#tk-ov').addEventListener('click', closeSheets);
    $$('[data-close]', phone).forEach(function (x) { x.addEventListener('click', closeSheets); });

    $('#tk-add').addEventListener('click', function () { $('#tf-err').classList.remove('show'); openSheet('#tk-sheet'); });

    $('#tf-submit').addEventListener('click', function () {
      var err = $('#tf-err');
      var title = $('#tf-title').value.trim();
      if (!title) { err.textContent = '标题为必填项'; err.classList.add('show'); return; }
      var due = $('#tf-due').value;
      var dueTxt = '无截止', dueTs = 0;
      if (due) {
        var d = new Date(due), now = new Date();
        var days = Math.ceil((d - now) / 86400000);
        dueTs = Math.max(days, 1);
        dueTxt = days <= 0 ? '今天 ' + String(d.getHours()).padStart(2, '0') + ':' + String(d.getMinutes()).padStart(2, '0')
          : days === 1 ? '明天 ' + String(d.getHours()).padStart(2, '0') + ':' + String(d.getMinutes()).padStart(2, '0')
          : (d.getMonth() + 1) + '-' + String(d.getDate()).padStart(2, '0');
      }
      tasks.push({
        id: nextId++, title: title, course: $('#tf-course').value,
        due: dueTxt, dueTs: dueTs, pri: $('#tf-pri').value,
        est: +$('#tf-est').value || 30, status: 'todo'
      });
      $('#tf-title').value = ''; $('#tf-note').value = '';
      closeSheets(); render();
      toast($('#tk-toast'), '已创建任务 · ' + title);
    });

    render();
  })();

  // ================= P4 智能安排 =================
  (function () {
    var phone = $('#p4'); if (!phone) return;
    var H0 = 6, ROW = 34;
    var courses = [
      { s: '08:00', e: '09:40', n: '高等数学' },
      { s: '10:10', e: '11:50', n: '大学英语' },
      { s: '14:00', e: '15:40', n: '线性代数' }
    ];
    var frees = [
      { s: '13:00', e: '14:00' },
      { s: '16:00', e: '18:00' },
      { s: '19:00', e: '21:30' }
    ];
    var PLAN_AI = [
      { s: '13:00', e: '14:00', t: '高数作业 §2.3', reason: '截止今天 22:00，午后首块优先清掉' },
      { s: '16:10', e: '16:40', t: '英语预习 Unit 3', reason: '轻量任务，衔接下午空闲段' },
      { s: '19:00', e: '20:00', t: '社团招新策划', reason: '晚间长待机段适合深度任务' },
      { s: '21:00', e: '21:25', t: '还图书馆《三体》', reason: '顺路轻量任务，收盘前完成' }
    ];
    var PLAN_GREEDY = [
      { s: '13:00', e: '14:00', t: '高数作业 §2.3', reason: '贪心：截止最近，填充最早待机段' },
      { s: '16:00', e: '17:00', t: '社团招新策划', reason: '贪心：次长空闲段整块利用' },
      { s: '17:10', e: '17:40', t: '英语预习 Unit 3', reason: '贪心：同段续排，间隔 10 分钟' },
      { s: '19:00', e: '19:25', t: '还图书馆《三体》', reason: '贪心：剩余任务顺次填充' }
    ];
    var mode = 'ai', accepted = 0, rejected = 0;

    function min(s) { return +s.slice(0, 2) * 60 + +s.slice(3, 5); }
    function fmt(m) { return String(Math.floor(m / 60)).padStart(2, '0') + ':' + String(m % 60).padStart(2, '0'); }

    function renderTimeline() {
      var tl = $('#ai-tl');
      var html = '';
      for (var h = H0; h <= 23; h++) {
        html += '<div class="hr">' + String(h).padStart(2, '0') + ':00</div><div class="lane"></div>';
      }
      html += '<div id="ai-blocks" style="position:absolute; left:46px; right:0; top:0; bottom:0;">';
      frees.forEach(function (f) {
        var top = (min(f.s) - H0 * 60) / 60 * ROW, hpx = (min(f.e) - min(f.s)) / 60 * ROW;
        html += '<div class="blk free" style="top:' + top + 'px; height:' + hpx + 'px; left:0; right:0;">待机</div>';
      });
      courses.forEach(function (c) {
        var top = (min(c.s) - H0 * 60) / 60 * ROW, hpx = (min(c.e) - min(c.s)) / 60 * ROW;
        html += '<div class="blk course" style="top:' + top + 'px; height:' + hpx + 'px; left:0; right:0;" title="' + c.n + ' ' + c.s + '-' + c.e + '">' + c.n + '</div>';
      });
      html += '</div>';
      tl.style.position = 'relative';
      tl.innerHTML = html;
    }

    function addBlock(b, state) {
      var layer = $('#ai-blocks'); if (!layer) return;
      var top = (min(b.s) - H0 * 60) / 60 * ROW, hpx = Math.max((min(b.e) - min(b.s)) / 60 * ROW, 16);
      var div = document.createElement('div');
      div.className = 'blk ai' + (state === 'pending' ? ' pending' : '');
      div.style.cssText = 'top:' + top + 'px; height:' + hpx + 'px; left:0; right:0;';
      div.textContent = b.s + ' ' + b.t;
      div.title = b.t + ' ' + b.s + '-' + b.e + ' · ' + b.reason;
      layer.appendChild(div);
      return div;
    }

    function renderSuggestions(plan, engine) {
      var box = $('#ai-sugg');
      box.innerHTML = '<div class="card" style="margin:0;"><div class="ct"><span>③ 建议 · ' + plan.length + ' 块</span><b>ENGINE: ' + engine.toUpperCase() + '</b></div>' +
        plan.map(function (b, i) {
          return '<div class="lesson" data-i="' + i + '" style="cursor:default;"><div class="tm">' + b.s + '<span>' + b.e + '</span></div>' +
            '<div class="lc"><div class="n">' + b.t + '</div><div class="r">' + b.reason + '</div>' +
            '<div style="margin-top:5px; display:flex; gap:6px;"><button class="pbtn pri sm" data-ok="' + i + '">接受</button><button class="pbtn ghost sm" data-no="' + i + '">拒绝</button></div></div></div>';
        }).join('') + '</div>';
      plan.forEach(function (b) { b._el = addBlock(b, 'pending'); });
      $$('[data-ok]', box).forEach(function (btn) {
        btn.addEventListener('click', function () {
          var i = +btn.dataset.ok, b = plan[i];
          if (b._el) { b._el.classList.remove('pending'); b._el.textContent = '✓ ' + b.s + ' ' + b.t; }
          var row = btn.closest('.lesson');
          row.querySelector('.lc div:last-child').remove();
          row.querySelector('.r').textContent = '已接受 · ' + b.reason;
          accepted++;
          toast($('#ai-toast'), '时间块已确认 · ' + b.s + ' ' + b.t);
        });
      });
      $$('[data-no]', box).forEach(function (btn) {
        btn.addEventListener('click', function () {
          var i = +btn.dataset.no, b = plan[i];
          if (b._el && b._el.parentElement) b._el.remove();
          var row = btn.closest('.lesson');
          row.style.opacity = '0.4';
          row.querySelector('.lc div:last-child').remove();
          row.querySelector('.r').textContent = '已拒绝';
          rejected++;
        });
      });
    }

    function generate(engine) {
      $$('#ai-blocks .blk.ai').forEach(function (b) { b.remove(); });
      accepted = 0; rejected = 0;
      var gen = $('#ai-gen');
      if (engine === 'deepseek') {
        $('#ai-engine').textContent = 'ENGINE: DEEPSEEK';
        gen.textContent = 'MAGI 分析中…'; gen.disabled = true; gen.style.opacity = '0.6';
        setTimeout(function () {
          gen.textContent = '重新生成'; gen.disabled = false; gen.style.opacity = '1';
          renderSuggestions(PLAN_AI, 'deepseek');
        }, 900);
      } else {
        $('#ai-engine').textContent = 'ENGINE: GREEDY';
        renderSuggestions(PLAN_GREEDY, 'greedy');
      }
    }

    $('#ai-gen').addEventListener('click', function () { generate(mode === 'ai' ? 'deepseek' : 'greedy'); });
    $('#ai-fallback').addEventListener('click', function () {
      mode = 'greedy';
      toast($('#ai-toast'), 'AI 不可用 → 贪心引擎接管', 2200);
      generate('greedy');
    });

    $('#ai-ctx-btn').addEventListener('click', function () {
      var pre = $('#ai-ctx');
      if (!pre.textContent) {
        var ctx = {
          date: '2026-09-07',
          busy: courses.map(function (c) { return { s: c.s, e: c.e, n: c.n }; }),
          tasks: [
            { id: 12, title: '高数作业 §2.3', due: '22:00', pri: 'q1', est: 60, course: '高数' },
            { id: 13, title: '英语预习 Unit 3', due: '明天 18:00', pri: 'q2', est: 30, course: '英语' },
            { id: 14, title: '社团招新策划', due: '周五', pri: 'q4', est: 120, course: null },
            { id: 15, title: '还图书馆《三体》', due: '周六', pri: 'q3', est: 15, course: null }
          ],
          prefs: { wake: '07:00', sleep: '23:30', lunch: '12:00-13:00', gap_min: 10, block_min: 25 }
        };
        pre.textContent = JSON.stringify(ctx, null, 2);
      }
      pre.style.display = pre.style.display === 'none' ? 'block' : 'none';
      $('#ai-ctx-btn').textContent = pre.style.display === 'none' ? '查看 AI 上下文 JSON' : '收起 JSON';
    });

    renderTimeline();
  })();

  // ================= P5 提醒 =================
  (function () {
    var phone = $('#p5'); if (!phone) return;
    $$('.sw', phone).forEach(function (sw) {
      sw.addEventListener('click', function () {
        sw.classList.toggle('on');
        var label = sw.previousElementSibling.textContent.split('·')[0].trim();
        toast($('#p5-toast'), (sw.classList.contains('on') ? '已开启 · ' : '已关闭 · ') + label);
      });
    });
  })();

  // ================= P6 数据与同步 =================
  (function () {
    var phone = $('#p6'); if (!phone) return;
    $('#p6-sync').addEventListener('click', function () {
      var b = $('#p6-sync');
      b.textContent = '同步中…'; b.disabled = true;
      setTimeout(function () {
        b.textContent = '立即同步'; b.disabled = false;
        toast($('#p6-toast'), '同步完成 · 0 条变更');
      }, 800);
    });
    $('#p6-export').addEventListener('click', function () {
      toast($('#p6-toast'), '已导出 magi-backup-20260907.json', 2200);
    });
  })();
})();
