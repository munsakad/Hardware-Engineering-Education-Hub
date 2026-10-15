document.addEventListener("DOMContentLoaded", async () => {
  const root = document.querySelector("#cms-content");
  try {
    const access = await apiRequest("/cms",{auth:true});
    document.querySelector("#cms-notice").textContent=access.message;
    root.innerHTML = `
      <div class="editor-grid">
        <section class="lesson-content"><h2>Courses</h2>
          <div class="field"><label for="course-select">Select course</label><select id="course-select"></select></div>
          <form id="course-editor">
            <div class="field"><label for="course-slug">Course slug (new courses only)</label><input id="course-slug" required maxlength="80" pattern="[a-z0-9]+(-[a-z0-9]+)*"></div>
            <div class="field"><label for="course-title">Title</label><input id="course-title" required maxlength="150"></div>
            <div class="field"><label for="course-category">Category</label><input id="course-category" required maxlength="60"></div>
            <div class="field"><label for="course-description">Description</label><textarea id="course-description" rows="4" maxlength="5000"></textarea></div>
            <button class="btn btn-primary">Save course</button>
          </form>
        </section>
        <section class="lesson-content"><h2>Lessons</h2>
          <div class="field"><label for="lesson-select">Select lesson</label><select id="lesson-select"></select></div>
          <form id="lesson-editor">
            <div class="field"><label for="lesson-slug">Lesson slug (new lessons only)</label><input id="lesson-slug" required maxlength="80" pattern="[a-z0-9]+(-[a-z0-9]+)*"></div>
            <div class="field"><label for="lesson-title">Title</label><input id="lesson-title" required maxlength="150"></div>
            <div class="field"><label for="lesson-text">Lesson text</label><textarea id="lesson-text" rows="14" required maxlength="100000" aria-describedby="plain-note"></textarea></div>
            <p id="plain-note">This editor saves plain text with line breaks. Saving an existing lesson replaces its rich formatting.</p>
            <button class="btn btn-primary">Save lesson</button>
            <button class="btn btn-secondary" type="button" id="preview-lesson">Preview text</button>
          </form>
          <div id="lesson-preview" class="text-preview" hidden></div>
        </section>
      </div><p id="cms-status" role="status" tabindex="-1"></p>
      ${access.mode==='browser' ? '<button class="btn btn-secondary" id="export-content">Export course catalog JSON</button>' : ''}`;
    const $ = id => document.getElementById(id);
    let current;
    async function loadCourses(selected="") {
      const all=await apiRequest("/courses");
      $("course-select").innerHTML='<option value="">+ Create course</option>'+all.map(c=>`<option value="${escapeText(c.slug)}">${escapeText(c.title)}</option>`).join("");
      $("course-select").value=selected;
      await loadCourse();
    }
    async function loadCourse() {
      const slug=$("course-select").value;
      current=slug ? await apiRequest(`/courses/${encodeURIComponent(slug)}`) : null;
      $("course-editor").reset();
      $("course-slug").disabled=Boolean(current);
      if(current) for(const key of ["slug","title","category","description"]) $("course-"+key).value=current[key]||"";
      $("lesson-select").innerHTML='<option value="">+ Create lesson</option>'+ (current?.lessons||[]).map(l=>`<option value="${escapeText(l.slug)}">${escapeText(l.title)}</option>`).join("");
      $("lesson-select").disabled=!current;
      await loadLesson();
    }
    async function loadLesson() {
      $("lesson-editor").reset(); $("lesson-preview").hidden=true;
      for(const el of $("lesson-editor").elements) el.disabled=!current;
      const slug=$("lesson-select").value;
      $("lesson-slug").disabled=!current || Boolean(slug);
      if(slug) {
        const lesson=await apiRequest(`/courses/${encodeURIComponent(current.slug)}/lessons/${encodeURIComponent(slug)}`);
        $("lesson-slug").value=lesson.slug; $("lesson-title").value=lesson.title;
        const doc=new DOMParser().parseFromString(lesson.content||"","text/html");
        doc.querySelectorAll("br").forEach(el=>el.replaceWith("\n"));
        doc.querySelectorAll("p,h1,h2,h3,li,pre,tr").forEach(el=>el.append("\n"));
        $("lesson-text").value=doc.body.textContent.trim();
      }
    }
    const report = e => {$("cms-status").textContent=e.message;$("cms-status").focus();};
    $("course-select").onchange=()=>loadCourse().catch(report);
    $("lesson-select").onchange=()=>loadLesson().catch(report);
    $("course-editor").onsubmit=async e=>{
      e.preventDefault();const button=e.currentTarget.querySelector("button");button.disabled=true;
      try {
        const slug=$("course-select").value;
        const body=Object.fromEntries(["slug","title","category","description"].map(k=>[k,$("course-"+k).value]));
        const saved=await apiRequest('/cms/courses'+(slug?'/'+encodeURIComponent(slug):''),{method:slug?'PUT':'POST',auth:true,body});
        await loadCourses(saved.slug);$("cms-status").textContent="Course saved. It is now available in the course catalog.";
      }catch(err){report(err);}finally{button.disabled=false;}
    };
    $("lesson-editor").onsubmit=async e=>{
      e.preventDefault();const button=e.currentTarget.querySelector('button');button.disabled=true;
      try{
        const slug=$("lesson-select").value, course=current.slug;
        const body=Object.fromEntries(["slug","title","text"].map(k=>[k,$("lesson-"+k).value]));
        const saved=await apiRequest(`/cms/courses/${encodeURIComponent(course)}/lessons`+(slug?'/'+encodeURIComponent(slug):''),{method:slug?'PUT':'POST',auth:true,body});
        await loadCourses(course);$("lesson-select").value=saved.slug;await loadLesson();
        $("cms-status").textContent="Lesson saved. Open the course to read the updated lesson.";
      }catch(err){report(err);}finally{button.disabled=false;}
    };
    $("preview-lesson").onclick=()=>{$("lesson-preview").hidden=false;$("lesson-preview").textContent=$("lesson-text").value;};
    if($("export-content")) $("export-content").onclick=async()=>{
      try {
        const data=await apiRequest('/cms/export',{auth:true});
        const url=URL.createObjectURL(new Blob([JSON.stringify(data,null,2)],{type:'application/json'}));
        const a=document.createElement('a');a.href=url;a.download='hardware-hub-courses.json';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
      } catch(e) { report(e); }
    };
    await loadCourses();
  }catch(e){root.textContent=e.message+". Log in with an administrator account to edit shared content.";}
});
