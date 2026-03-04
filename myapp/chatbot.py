from sentence_transformers import SentenceTransformer, util
import numpy as np

# Initialize the Sentence-BERT model
model = SentenceTransformer('paraphrase-MiniLM-L6-v2')

# Define the question-answer pairs for the chatbot
qa_pairs = [
    # **General College Information**
    ("What is the history of the college?",
     "The college was founded in 1950 with the goal of providing quality education to students. Over the years, it has expanded into a leading institution offering diverse programs in various fields of study."),

    ("What is the college's mission?",
     "The mission of the college is to provide students with a transformative educational experience, fostering academic excellence, personal growth, and global citizenship."),

    ("Who is the current president of the college?",
     "The current president of the college is Dr. Jane Smith, who has been serving since 2018. She has worked on expanding the college's international programs and enhancing campus facilities."),

    ("What are the college's core values?",
     "The college is committed to integrity, diversity, inclusivity, sustainability, and academic excellence. These core values guide the college community's daily operations and culture."),

    # **Faculty and Staff Information**
    ("How can I contact my professor?",
     "You can contact your professors via email, or during their scheduled office hours. Office hours and contact information can be found on the faculty directory page on the website."),

    ("How do I become a professor at the college?",
     "To become a professor at the college, you typically need a Ph.D. in your field, a record of academic research, and teaching experience. Open faculty positions are posted on the college's career page."),

    ("Is there a faculty development program?",
     "Yes, the college offers continuous professional development programs for faculty members to enhance their teaching, research, and leadership skills."),

    ("What staff services are available on campus?",
     "The college provides a range of staff services including HR support, counseling, wellness programs, and professional development workshops."),

    # **Academic Programs and Departments**
    ("What departments are available at the college?",
     "The college has a wide range of departments including Arts, Science, Engineering, Business Administration, Computer Science, Social Sciences, and Health Sciences."),

    ("What programs are available in Computer Science?",
     "The Computer Science department offers undergraduate and graduate programs such as B.Sc. in Computer Science, M.Sc. in Computer Science, and specialized courses like Artificial Intelligence, Data Science, and Cybersecurity."),

    ("What courses are offered in Business Administration?",
     "The Business Administration department offers courses in Finance, Marketing, Management, Entrepreneurship, and Business Ethics. You can check the course catalog for the full list."),

    ("What is the admissions process for graduate programs?",
     "To apply for graduate programs, you need to complete an online application form, submit your academic transcripts, provide letters of recommendation, and in some cases, take an entrance exam or interview."),

    ("Are there any dual-degree programs?",
     "Yes, the college offers dual-degree programs in fields such as Engineering and Business Administration, allowing students to earn two degrees in a shorter time frame."),

    ("How do I apply for honors programs?",
     "To apply for an honors program, you must meet the GPA requirements and submit an application during the registration period. Specific details can be found on the college website."),

    # **Campus and Student Life**
    ("What is the campus size?",
     "The college campus spans 100 acres and features state-of-the-art classrooms, research labs, recreational facilities, and green spaces for students and faculty."),

    ("Are there on-campus housing options?",
     "Yes, there are multiple dormitories available for both undergraduate and graduate students. You can apply for campus housing through the student portal."),

    ("What is there to do for fun on campus?",
     "The campus offers various recreational activities including sports, student clubs, a music room, drama workshops, and several student-run events throughout the year."),

    ("Is there a student union?",
     "Yes, the student union organizes campus events, social gatherings, and provides support for student rights and academic needs."),

    ("How do I get involved in clubs and student organizations?",
     "You can sign up for clubs and student organizations through the student portal. The campus has a variety of clubs ranging from academic to recreational and social interests."),

    ("Can I participate in sports?",
     "Yes, the college has sports program where students can participate in sports like basketball, soccer, and volleyball. Registration details are available through the campus sports office."),

    ("Is there a student newspaper?",
     "Yes, the college has a student-run newspaper that covers campus news, events, and academic achievements. You can contribute as a writer, editor, or photographer."),

    # **Sports and Recreation**
    ("What sports are offered on campus?",
     "The college offers various sports including soccer, basketball, volleyball, tennis, swimming, and athletics. The sports complex has dedicated facilities for both team and individual sports."),

    ("Are there varsity teams?",
     "Yes, the college has competitive varsity teams in football, basketball, track and field, and other sports. Tryouts are held at the beginning of each semester."),

    ("How can I join a sports team?",
     "To join a sports team, you need to attend tryouts, which are held by the respective department at the start of each semester. Information is posted on the sports office bulletin board."),

    ("Is there a swimming pool on campus?",
     "Yes, the college has an Olympic-sized swimming pool located in the sports complex. Students can access it during designated hours with their student ID."),

    ("What fitness classes are offered on campus?",
     "The college offers fitness classes including yoga, pilates, Zumba, and strength training. Classes are held in the gym and are free for students with a valid ID."),

    # **Events and Festivals**
    ("What events are held on campus?",
     "The college hosts a variety of events including 'College Fest', sports competitions, guest lectures, cultural festivals, career fairs, and workshops throughout the year."),

    ("What is the annual College Fest?",
     "The College Fest is the college's annual celebration that features music, dance performances, workshops, and guest speakers. It's a major highlight of the academic year."),

    ("How can I participate in campus events?",
     "You can participate in campus events by registering on the event page or contacting the event organizers. Many events are open to all students."),

    ("Are there any guest speakers visiting soon?",
     "Yes, the college regularly hosts guest speakers from various fields including technology, business, politics, and the arts. Check the campus events page for upcoming talks."),

    # **Campus Facilities**
    ("Are there research labs on campus?",
     "Yes, the college has dedicated research labs in fields like Chemistry, Computer Science, Engineering, and Medical Sciences. These labs are available for students involved in research projects."),

    ("What kind of dining options are available on campus?",
     "The campus has multiple dining facilities including the main cafeteria, a coffee shop, and a food court. There are also vending machines and snack bars located around the campus."),

    ("Are there any quiet study areas?",
     "Yes, the library and several designated study rooms across campus provide quiet environments for studying. The study areas can be booked online through the student portal."),

    ("Is there a student lounge?",
     "Yes, the student lounge is located near the student center. It is a relaxed space where students can socialize, study, or relax between classes."),

    ("How do I access campus Wi-Fi?",
     "Campus Wi-Fi is available to all students. You can connect using your student credentials. If you encounter any issues, the IT support office can assist."),

    # **Financial Aid and Scholarships**
    ("What types of financial aid are available?",
     "The college offers financial aid through scholarships, grants, and student loans. You can apply for aid through the Financial Aid Office on the website."),

    ("How do I apply for a scholarship?",
     "To apply for scholarships, visit the Financial Aid section of the website. Applications are typically due in March and April."),

    ("Are there work-study programs?",
     "Yes, the college offers work-study programs that allow students to work part-time on campus while earning academic credit. Jobs are listed on the student portal."),

    ("What are the tuition fees?",
     "Tuition fees vary depending on the program you choose. You can check the fee schedule on the admissions page or contact the bursar’s office for detailed information."),

    ("How can I apply for a student loan?",
     "You can apply for a student loan through the Financial Aid Office. The application process includes submitting financial documents and meeting eligibility criteria."),

    # **General Questions**
    ("Thank you for the information!", "You're welcome! If you have any more questions, feel free to ask!"),
    ("Goodbye!", "Goodbye! Have a wonderful day!"),
]

# Prepare the questions and answers
questions = [qa[0] for qa in qa_pairs]
answers = [qa[1] for qa in qa_pairs]

# Encode the questions using Sentence-BERT model
question_embeddings = model.encode(questions, convert_to_tensor=True)


# Function to handle chatbot interaction
def chatbot(query):
    # Encode the user's question
    query_embedding = model.encode(query, convert_to_tensor=True)

    # Compute cosine similarities between the query and all stored questions
    similarities = util.pytorch_cos_sim(query_embedding, question_embeddings)[0]

    # Find the index of the most similar question
    best_match_idx = np.argmax(similarities)
    best_match_similarity = similarities[best_match_idx]

    # If the similarity is high enough, return the corresponding answer
    if best_match_similarity > 0.7:  # threshold to ensure a good match
        return answers[best_match_idx]
    else:
        return "I'm sorry, I don't have that information. Please visit the website or contact support."


# Start the chatbot conversation loop
print("Hello! I am your college assistant chatbot. How can I help you today?")
print("Type 'exit' to end the conversation.")

while True:
    # Take user input from the keyboard
    user_input = input("You: ")

    # Exit the loop if the user types 'exit'
    if user_input.lower() == 'exit':
        print("Goodbye! Have a great day!")
        break

    # Get chatbot response
    response = chatbot(user_input)

    # Output the chatbot's response
    print(f"Chatbot: {response}")
