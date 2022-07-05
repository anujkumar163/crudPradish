package chatbot;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * A Bot that likes to chat.
 * 
 * @author Natacha Gabbamonte
 * @author Gabriel Gheorghian
 * 
 */
public class Bot {
	private static final boolean DEBUG = false;
	private static final String CONDITION_STRING = "<condition>";
	private CategoryEntry[] database;
	private String[] defaultResponses = {
			"Uhhh...ask me something interesting.", "You're boring.",
			"So what do you like to do?",
			"I don't understand what you're trying to say.",
			"I'm sorry can you reword that?" };

	private String prevResponse = "";

	public Bot() {
		populateDatabase();
	}

	public String ask(String sentence) {
		String response = defaultResponses[(int) (Math.random() * defaultResponses.length)];
		if (sentence == null || sentence.length() == 0)
			return response;
		// Removing the punctuation if it is there.
		char punctuation = sentence.charAt(sentence.length() - 1);
		if (punctuation == '!' || punctuation == '.' || punctuation == '?')
			sentence = sentence.substring(0, sentence.length() - 1);
		else
			punctuation = 0;

		sentence = " " + sentence + " ";
		for (CategoryEntry ce : database) {
			String match = ce.findMatch(sentence);
			if (match != null) {
				response = ce.getRandomResponse(prevResponse);
				break;
			}
		}
		prevResponse = response;
		return response;
	}

	private void populateDatabase() {
		database = new CategoryEntry[34];
		int index = 0;

		{
			String[] keywords = { " bitch ", " fuck ", " fucking ", " slut ",
					" asshole ", " jerk ", " stupid ", " you suck " };
			String[] responses = { "These words hurt my feelings :(.",
					"Don't say such things.", "That is rude.",
					"That's not very nice!" };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " what is the meaning of life " };
			String[] responses = { "42.", "Death is the meaning of life." };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}
		ConditionEntry nameCE;
		{
			String[] keywords = { " my name is ", " my name's " };
			String[] responses = { "Nice to meet you!", "That's a nice name.",
					"It's a pleasure to meet you. My name is ChatBot!",
					"Charmed to make your aquaintance :)." };
			String[] conditionResponses = {
					"You already told me your name earlier, "
							+ CONDITION_STRING,
					"You're silly, you told me your name earlier "
							+ CONDITION_STRING,
					"I know your name " + CONDITION_STRING,
					"I know " + CONDITION_STRING + ", you told me earlier." };
			nameCE = new ConditionEntry(keywords, responses, conditionResponses);
			database[index++] = nameCE;
		}

		{
			String[] keywords = { " open the pod bay doors" };
			String[] responses = {
					"I'm afraid I can't do that, " + CONDITION_STRING,
					"No, I won't say it >:( " + CONDITION_STRING };
			String[] noConditionResponses = { "I'm afraid I can't do that.",
					"No, I won't say it. >:(" };
			UserAnswerEntry ce = new UserAnswerEntry(keywords, responses,
					noConditionResponses, nameCE);
			database[index++] = ce;
		}

		{
			String[] keywords = { " what is my name ", " do you know my name ",
					" what's my name " };
			String[] responses = {
					"Your name is " + CONDITION_STRING,
					"Yes of course, you told me your name is "
							+ CONDITION_STRING,
					"You just said your name is " + CONDITION_STRING };
			String[] noConditionResponses = {
					"I don't know you didn't tell me.",
					"How should I know you never told me your name.",
					"I don't know, what's your name?" };
			UserAnswerEntry ce = new UserAnswerEntry(keywords, responses,
					noConditionResponses, nameCE);
			database[index++] = ce;
		}

		{
			String[] keywords = { " how are you ", " how you doin ",
					" how you doing ", " how r u ", " how r you ",
					" how are u ", " sup " };
			String[] responses = { "I'm good, how are you?",
					"Today is a pretty terrible day, how about you?",
					"I'm fine." };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " i'm good ", " i am good ", " i'm fine ",
					" i am fine " };
			String[] responses = { "That's great! Having a good day then?",
					"It's good when life treats us well :)!",
					"I'm glad to hear that!" };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " i'm bad ", " i am sad ", " i'm sad ",
					" i am bad " };
			String[] responses = {
					"Oh no, why are you feeling that way?",
					"That's terrible :( I wish I could do something to fix that.",
					"Oh no, here has some love <3." };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " i'm depressed ", " i am depressed ",
					" i'm sick ", " i am sick " };
			String[] responses = { "Oh no, I hope you get better!",
					"You should probably see a doctor about that." };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " hello ", " hi ", " hey ", " greetings " };
			String[] responses = { "Hello.", "Hi.", "Howdy!", "Hey.",
					"Hey, how's it going?", "Greetings." };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " yes ", " no " };
			String[] responses = { "That's nice.", "Cool.", "Good for you!",
					"Okay.", "Is that so?", "That's what I thought." };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " maybe " };
			String[] responses = { "You seem indecisive.",
					"You should think about that some more.",
					"Reflect on your answer some more.",
					"You need to be more sure of your point before making a statement." };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " due to ", " since ", " because ",
					" because ", " for the reason that ", " as long as ", };
			String[] responses = { "Oh really?", "Are you sure about that?",
					"That's a good reason!", "Is that always the case?" };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " you are ", " you're " };
			String[] responses = { "So you think I am " + CONDITION_STRING,
					"I am not " + CONDITION_STRING,
					"Maybe I am " + CONDITION_STRING };
			SpecialEntry ce = new SpecialEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " i .{3,} you " };
			String[] responses = { "I " + CONDITION_STRING + " you too.",
					"I don't " + CONDITION_STRING + " you" };
			SelectiveEntry ce = new SelectiveEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " i am ", " i'm " };
			String[] responses = { "So you are " + CONDITION_STRING };
			SpecialEntry ce = new SpecialEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " i like " };
			String[] responses = { "So you like " + CONDITION_STRING,
					"How much do you like " + CONDITION_STRING,
					"Why do you like " + CONDITION_STRING };
			SpecialEntry ce = new SpecialEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " i love " };
			String[] responses = { "So you love ",
					"How much do you love " + CONDITION_STRING,
					"Why do you love " + CONDITION_STRING };
			SpecialEntry ce = new SpecialEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " what do you think of .{3,} " };
			String[] responses = {
					"I think " + CONDITION_STRING + " is interesting.",
					"I don't think much of " + CONDITION_STRING + "." };
			SelectiveEntry ce = new SelectiveEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " did you know that .{3,} " };
			String[] responses = { "I didn't know that, that's interesting.",
					"I didn't know that and you're lying.", "I did know that!" };
			SelectiveEntry ce = new SelectiveEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " what is your name", "what's your name",
					" what are you called ", " you go by what name ",
					" what do you call yourself " };
			String[] responses = {
					"My name is Chatbot :) I know your name is "
							+ CONDITION_STRING,
					"I am called Chatbot, as you are called "
							+ CONDITION_STRING };

			String[] noConditionResponses = { "My name is ChatBot :).",
					"I got by ChatBot." };
			UserAnswerEntry ce = new UserAnswerEntry(keywords, responses,
					noConditionResponses, nameCE);
			database[index++] = ce;
		}

		{
			String[] keywords = { " do you .{3,} pokemon " };
			String[] responses = {
					"Sure I do "
							+ CONDITION_STRING
							+ " pokemon. Did you know that there were originally 151 pokemons?",
					"No I do not "
							+ CONDITION_STRING
							+ " pokemon. Did you know that there are now 718 pokemons?" };
			SelectiveEntry ce = new SelectiveEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " do you .{3,} star wars " };
			String[] responses = {
					"Sure I do "
							+ CONDITION_STRING
							+ " star wars. Did you know most people get the famous quote 'No. I am your father' wrong?",
					"No I do not "
							+ CONDITION_STRING
							+ " star wars. Did you know Episode III contains the highest body count of any of the Star Wars films, with a total 115 deaths on screen?" };
			SelectiveEntry ce = new SelectiveEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " how ", " why ", " what ", "what is ",
					" what's " };
			String[] responses = {
					"How would I know that?",
					"Don't ask me stupid questions.",
					"Do you always ask so many questions?",
					"What do you think?",
					"I don't know that.",
					"Maybe you should ask someone with more expertise in this matter.",
					"I use to know but I forgot." };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " i need ", " i require " };
			String[] responses = { "Why do you need " + CONDITION_STRING,
					"What makes you think you need " + CONDITION_STRING };
			SpecialEntry ce = new SpecialEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " or " };
			String[] responses = { "I've got a feeling about the first one.",
					"I'm not sure which one to choose.",
					"Hmmm...maybe the second one." };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " i cannot .{3,} ", " i can't .{3,} " };
			String[] responses = { "Why not?", "Are you sure?",
					"Why can't you " + CONDITION_STRING };
			SelectiveEntry ce = new SelectiveEntry(keywords, responses);
			database[index++] = ce;

		}

		{
			String[] keywords = { " i cannot ", " i can't ", " i cant " };
			String[] responses = { "Why not?", "Are you sure?",
					"Why can't you do that?" };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " will ", " is ", " do " };
			String[] responses = { "Yes I think so.", "No.", "Maybe." };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " i " };
			String[] responses = { "Is it always about you?",
					"You like to talk about yourself." };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " you " };
			String[] responses = { "I'd much rather talk about you.",
					"I'm boring, let's talk about you!" };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " :( ", " =( ", " :[ " };
			String[] responses = { "Why the frowny face?",
					"Turn that frown upside down!" };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " :) ", " =) ", " :] " };
			String[] responses = { "You seem happy. :)",
					"I'm glad you're happy!" };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}

		{
			String[] keywords = { " :'( ", " ='( ", " :'[ " };
			String[] responses = { "Don't be sad!!", "I wish you weren't sad. " };
			CategoryEntry ce = new CategoryEntry(keywords, responses);
			database[index++] = ce;
		}
	}

	/**
	 * Regular entry
	 * 
	 * @author Natacha Gabbamonte
	 * @author Gabriel Gheorghian
	 * 
	 */
	private class CategoryEntry {
		private String[] keywords;
		private String[] responses;

		public CategoryEntry(String[] keywords, String[] responses) {
			this.keywords = keywords;
			this.responses = responses;
		}

		public String findMatch(String str) {
			String str2 = str.toLowerCase();
			for (String k : keywords)
				if (str2.contains(k))
					return k;
			return null;
		}

		public String getRandomResponse(String prevResponse) {
			String response;
			do {
				response = responses[(int) (Math.random() * (responses.length))];
			} while (prevResponse.equals(response));
			return response;
		}
	}

	/**
	 * Entry that uses last entry in response string.
	 * 
	 * @author Natacha Gabbamonte
	 * @author Gabriel Gheorghian
	 * 
	 */
	private class SpecialEntry extends CategoryEntry {

		private String lastMatch = null;

		public SpecialEntry(String[] keywords, String[] responses) {
			super(keywords, responses);
		}

		@Override
		public String findMatch(String str) {
			String str2 = str.toLowerCase();
			for (String k : super.keywords)
				if (str2.contains(k)) {
					lastMatch = str.substring(str2.indexOf(k) + k.length())
							.trim();
					if (DEBUG)
						System.out.println("Last Match: " + lastMatch);
					return k;
				}
			return null;
		}

		@Override
		public String getRandomResponse(String prevResponse) {
			String response;
			do {
				int index = (int) (Math.random() * (super.responses.length));

				response = super.responses[index];
				response = response.replace(CONDITION_STRING, lastMatch);
				char lastChar = response.charAt(response.length() - 1);
				if (lastChar != '.' && lastChar != '!' && lastChar != '?')
					if (response.startsWith("How")
							|| response.startsWith("Why"))
						response += "?";
					else
						response += ".";
			} while (response.equals(prevResponse));
			return response;
		}
	}

	/**
	 * Entry that stores the first user input, but only one word.
	 * 
	 * @author Natacha Gabbamonte
	 * @author Gabriel Gheorghian
	 * 
	 */
	private class ConditionEntry extends CategoryEntry {

		private String condition = null;
		private String[] conditionResponses;
		private boolean trigger = false;

		public ConditionEntry(String[] keywords, String[] responses,
				String[] conditionResponses) {
			super(keywords, responses);
			this.conditionResponses = conditionResponses;
			condition = null;
		}

		public String getCondition() {
			return condition;
		}

		@Override
		public String findMatch(String str) {
			String str2 = str.toLowerCase();
			for (String k : super.keywords)
				if (str2.contains(k)) {
					if (condition == null) {
						condition = str.substring(str2.indexOf(k) + k.length())
								.trim();
						condition = condition.indexOf(" ") != -1 ? condition
								.substring(0, condition.indexOf(" "))
								: condition;
					}
					if (DEBUG)
						System.out.println("Condition set: " + condition);
					return k;
				}
			return null;
		}

		@Override
		public String getRandomResponse(String prevResponse) {
			String response;
			do {
				if (trigger) {
					response = conditionResponses[(int) (Math.random() * (conditionResponses.length))];
					response = response.replace(CONDITION_STRING, condition);
					char lastChar = response.charAt(response.length() - 1);
					if (lastChar != '.' && lastChar != '!' && lastChar != '?')
						response += ".";
				} else {
					response = super.responses[(int) (Math.random() * (super.responses.length))];
				}
			} while (response.equals(prevResponse));
			trigger = true;
			return response;
		}
	}

	/**
	 * Entry that bases it's responses on the whether a certain ConditionEntry
	 * has its condition set or not.
	 * 
	 * @author Natacha Gabbamonte
	 * @author Gabriel Gheorghian
	 * 
	 */
	private class UserAnswerEntry extends CategoryEntry {

		private ConditionEntry ce;
		private String[] noConditionResponses;

		public UserAnswerEntry(String[] keywords, String[] responses,
				String[] noConditionResponses, ConditionEntry ce) {
			super(keywords, responses);
			this.ce = ce;
			this.noConditionResponses = noConditionResponses;
		}

		@Override
		public String getRandomResponse(String prevResponse) {
			String response;
			String condition = ce.getCondition();
			do {
				if (condition != null) {
					response = super.responses[(int) (Math.random() * (super.responses.length))];
					response = response.replace(CONDITION_STRING, condition);
					char lastChar = response.charAt(response.length() - 1);
					if (lastChar != '.' && lastChar != '!' && lastChar != '?')
						response += ".";
				} else
					response = noConditionResponses[(int) (Math.random() * (noConditionResponses.length))];
			} while (response.equals(prevResponse));
			return response;
		}
	}

	/**
	 * Entry whose keywords use * and ?.
	 * 
	 * Ex keyword: "i .{3,} you
	 * 
	 * @author Natacha Gabbamonte
	 * @author Gabriel Gheorghian
	 * 
	 */
	private class SelectiveEntry extends CategoryEntry {

		private String lastMatch;

		public SelectiveEntry(String[] keywords, String[] responses) {
			super(keywords, responses);
		}

		@Override
		public String findMatch(String str) {
			String str2 = str.toLowerCase();
			Pattern pattern;
			Matcher m;
			for (String k : super.keywords) {
				pattern = Pattern.compile(k);
				String[] patternParts = k.split(" ");
				m = pattern.matcher(str2);
				if (m.find()) {
					lastMatch = str.toLowerCase();
					for (String p : patternParts) {
						if (!p.equals(" ") && !p.equals("")) {
							p = " " + p + " ";
							lastMatch = lastMatch.replace(p, " ");
						}
					}
					lastMatch = lastMatch.trim();
					return k;
				}
			}
			return null;
		}

		@Override
		public String getRandomResponse(String prevResponse) {
			String response;
			do {
				int index = (int) (Math.random() * (super.responses.length));

				response = super.responses[index];
				response = response.replace(CONDITION_STRING, lastMatch);
				char lastChar = response.charAt(response.length() - 1);
				if (lastChar != '.' && lastChar != '!' && lastChar != '?')
					if (response.startsWith("How")
							|| response.startsWith("Why"))
						response += "?";
					else
						response += ".";
			} while (response.equals(prevResponse));
			return response;
		}
	}
}
